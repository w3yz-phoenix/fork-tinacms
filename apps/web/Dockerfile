ARG PRERELEASE_IMAGE
ARG INSTALL_IMAGE

FROM ${PRERELEASE_IMAGE} AS prerelease
FROM ${INSTALL_IMAGE} AS install

FROM oven/bun:1-alpine AS release

WORKDIR /usr/src/app

COPY --from=prerelease /temp/export/web .
COPY --from=install /temp/export/node_modules.prod ./node_modules

# run the app
USER bun
EXPOSE 3000/tcp
CMD [ "bun", "run", "start" ]

RUN echo "Building web"
