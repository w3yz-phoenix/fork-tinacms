# use the official Bun image
# see all versions at https://hub.docker.com/r/oven/bun/tags
FROM oven/bun:1-alpine AS base
WORKDIR /usr/src/app

RUN apk add --no-cache rsync bash curl \
  && sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/bin

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
  && mkdir -p /temp/export \
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

# copy node_modules from temp directory
# then copy all (non-ignored) project files into the image
FROM base AS prerelease

COPY . .
COPY --from=install /temp/export/node_modules.dev ./node_modules

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
