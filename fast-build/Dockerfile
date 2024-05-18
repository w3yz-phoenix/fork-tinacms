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

ARG NEXT_PUBLIC_ROOT_DOMAIN
ARG NEXT_PUBLIC_SHOP_NAME
ARG NEXT_PUBLIC_MONGO_PORT
ARG MY_PERSONAL_GITHUB_TOKEN

ENV NODE_ENV=production
ENV GITHUB_OWNER=w3yz-phoenix
ENV GITHUB_REPO=live
ENV GITHUB_BRANCH=main
ENV NEXTAUTH_SECRET="change-me"
ENV GITHUB_PERSONAL_ACCESS_TOKEN="${MY_PERSONAL_GITHUB_TOKEN}"
ENV TINA_PUBLIC_IS_LOCAL="false"
ENV NEXT_PUBLIC_TINA_IS_LOCAL="false"

ENV SHOP_DOMAIN=
ENV MONGODB_URI=
ENV NEXT_PUBLIC_ROOT_DOMAIN=
ENV NEXT_PUBLIC_SHOP_NAME=
ENV NEXT_PUBLIC_URL=
ENV NEXT_PUBLIC_ECOM_API_URL=
ENV NEXT_PUBLIC_ECOM_NAME=
ENV NEXT_PUBLIC_SHOP_DOMAIN=
ENV NEXT_PUBLIC_CMS_BASE_URL=

USER bun
WORKDIR /apps/storefront
CMD ["bun", "start"]
