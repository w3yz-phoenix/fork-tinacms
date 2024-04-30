# use the official Bun image
# see all versions at https://hub.docker.com/r/oven/bun/tags
FROM oven/bun:1-alpine as base
WORKDIR /usr/src/app

RUN apk add --no-cache just bash

# this will cache the manifest files
FROM base AS collect-files

RUN apk add --no-cache rsync bash

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
# COPY --from=install /temp/export/node_modules.dev ./node_modules

# # [optional] tests & build
# ENV NODE_ENV=production
# RUN bun --bun test
# RUN bun --bun run build

# RUN mkdir -p /temp/export

# WORKDIR /temp/export

# RUN mkdir -p /temp/export \
#   && cd /temp/export \
#   && cp /usr/src/app/package.json ./package.json \
#   && cp -r /usr/src/app/public ./public \
#   && cp -r /usr/src/app/.next ./.next \
#   && rm -rf /usr/src/app/

# copy production dependencies and source code into final image
FROM base AS release

COPY --from=prerelease /temp/export/ .
COPY --from=install /temp/export/node_modules.prod ./node_modules

# run the app
USER bun
EXPOSE 3000/tcp
ENTRYPOINT [ "bun", "--bun", "run", "start" ]
