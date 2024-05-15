ARG DEVBOX_IMAGE
FROM $DEVBOX_IMAGE AS base

USER root:root
RUN mkdir -p /temp && chown ${DEVBOX_USER}:${DEVBOX_USER} /temp
USER ${DEVBOX_USER}:${DEVBOX_USER}

# this will cache the manifest files
FROM base AS collect-files

# copy all project files into the image
COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} . /temp/all-files

# copy only the package.json files in every package
RUN devbox run -- bash -c "\
  rsync -avm --include='*/' \
    --include='package.json' \
    --include='bun.lockb' \
    --exclude='*' \
    /temp/all-files /temp/monorepo \
    && mkdir -p /temp/export \
    && mv /temp/monorepo/all-files /temp/export/app \
    && rm -rf /temp/all-files \
    && rm -rf /temp/monorepo \
  "

# install dependencies into temp directory
# this will cache them and speed up future builds
FROM base AS install

RUN mkdir -p /temp/export
RUN mkdir -p /temp/dev

COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} --from=collect-files /temp/export/app /temp/dev

RUN devbox run -- bash -c "cd /temp/dev && bun install --frozen-lockfile"
RUN devbox run -- bash -c "mv /temp/dev/node_modules /temp/export/node_modules.dev"

RUN devbox run -- bash -c "cd /temp/dev && bun install --frozen-lockfile --production"
RUN devbox run -- bash -c "mv /temp/dev/node_modules /temp/export/node_modules.prod"

# copy node_modules from temp directory
# then copy all (non-ignored) project files into the image
FROM base AS prerelease

COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} . .
COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} --from=install /temp/export/node_modules.dev ./node_modules

ENV NODE_ENV=production

RUN devbox run -- bash -c "\
task build \
  && mkdir -p /temp/ \
  && mv dist/ /temp/export \
  && rm -rf /code \
"
