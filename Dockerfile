# use the official Bun image
# see all versions at https://hub.docker.com/r/oven/bun/tags
FROM jetpackio/devbox:latest AS base

# Installing your devbox project
WORKDIR /code
USER root:root
RUN mkdir -p /code && chown ${DEVBOX_USER}:${DEVBOX_USER} /code
USER ${DEVBOX_USER}:${DEVBOX_USER}
COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.json devbox.json
COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.lock devbox.lock

RUN devbox run -- echo "Installed Packages."

USER root:root
RUN mkdir -p /temp && chown ${DEVBOX_USER}:${DEVBOX_USER} /temp
USER ${DEVBOX_USER}:${DEVBOX_USER}

SHELL ["devbox", "run", "--", "bash", "-c"]

# this will cache the manifest files
FROM base AS collect-files

# copy all project files into the image
COPY . /temp/all-files

# copy only the package.json files in every package
RUN rsync -avm --include='*/' \
  --include='package.json' \
  --include='bun.lockb' \
  --exclude='*' \
  /temp/all-files /temp/monorepo \
  && mkdir -p /temp/export && chown ${DEVBOX_USER}:${DEVBOX_USER} /temp/export \
  && mv /temp/monorepo/all-files /temp/export/app \
  && rm -rf /temp/all-files \
  && rm -rf /temp/monorepo

# install dependencies into temp directory
# this will cache them and speed up future builds
FROM base AS install

RUN mkdir -p /temp/export
RUN mkdir -p /temp/dev

COPY --from=collect-files /temp/export/app /temp/dev

RUN cd /temp/dev && bun install --frozen-lockfile
RUN mv /temp/dev/node_modules /temp/export/node_modules.dev

RUN cd /temp/dev && bun install --frozen-lockfile --production
RUN mv /temp/dev/node_modules /temp/export/node_modules.prod

FROM base AS prerelease

COPY . .
COPY --from=install /temp/export/node_modules.dev ./node_modules

FROM prerelease AS final-build

ENV NODE_ENV=production

RUN task build \
  && mkdir -p /temp/ \
  && mv dist/ /temp/export \
  && rm -rf /usr/src/app

# copy production dependencies and source code into final image
FROM base AS release

COPY --from=prerelease /temp/export/storefront .
COPY --from=install /temp/export/node_modules.prod ./node_modules

# run the app
USER bun
EXPOSE 3000/tcp
CMD [ "bun", "--bun", "run", "start" ]
