FROM alpine AS collector

WORKDIR /workdir

COPY ./dist.tgz /workdir
RUN tar -xzf dist.tgz \
  && mkdir -p /export \
  && mv dist/storefront /export/storefront \
  && cp -r dist/node_modules /export/storefront/node_modules \
  && mv dist/tinacms /export/tinacms \
  && mv dist/node_modules /export/tinacms/node_modules \
  && rm -rf /workdir

WORKDIR /export

FROM oven/bun:1-alpine AS storefront__release

RUN mkdir -p /apps

COPY --from=collector ./export/storefront /apps/storefront
COPY --from=collector ./export/tinacms /apps/tinacms

ENV PORT=3000

ARG ROOT_DOMAIN
ARG SHOP_NAME
ARG MONGO_PORT
ARG MY_PERSONAL_GITHUB_TOKEN

ENV ROOT_DOMAIN=${ROOT_DOMAIN}
ENV SHOP_NAME=${SHOP_NAME}

ENV NODE_ENV=production
ENV GITHUB_PERSONAL_ACCESS_TOKEN="${MY_PERSONAL_GITHUB_TOKEN}"
ENV TINA_PUBLIC_IS_LOCAL="false"
ENV NEXT_PUBLIC_TINA_IS_LOCAL="false"

USER bun
WORKDIR /apps/storefront
CMD ["bun", "start"]
