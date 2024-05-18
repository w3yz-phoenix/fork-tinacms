FROM jetpackio/devbox:latest AS base_devbox

USER root:root

ARG B_CURRENT="/workspace/current"
ARG B_INPUTS_ROOT="/workspace/inputs"
ARG B_OUTPUTS_ROOT="/workspace/outputs"

RUN mkdir -p \
  "${B_CURRENT}" \
  "${B_INPUTS_ROOT}" \
  "${B_OUTPUTS_ROOT}"

WORKDIR "${B_CURRENT}"

# Fix permissions start
RUN chown -R ${DEVBOX_USER}:${DEVBOX_USER} /workspace
# Fix permissions end

COPY ./devbox.json /workspace/devbox.json
COPY ./devbox.lock /workspace/devbox.lock

# Fix permissions start
RUN chown -R ${DEVBOX_USER}:${DEVBOX_USER} /workspace
# Fix permissions end

# Devbox session start
USER ${DEVBOX_USER}:${DEVBOX_USER}
RUN devbox run -- echo "Installed Packages."
USER root:root
# Devbox session end

# copy all project files into the image
COPY . .
# Fix permissions start
RUN chown -R ${DEVBOX_USER}:${DEVBOX_USER} /workspace
# Fix permissions end

RUN rm -rf ./devbox.json ./devbox.lock

FROM base_devbox AS project_manifest__base

ARG B_CURRENT=/workspace/current
ARG B_INPUTS_ROOT=/workspace/inputs
ARG B_OUTPUTS_ROOT=/workspace/outputs

ARG C_OUTPUT="${B_OUTPUTS_ROOT}/project_manifest__base"
RUN mkdir -p "${C_OUTPUT}"

# Fix permissions start
RUN chown -R ${DEVBOX_USER}:${DEVBOX_USER} /workspace
# Fix permissions end

# Devbox session start
USER ${DEVBOX_USER}:${DEVBOX_USER}
RUN devbox run -- rsync -avm --include='*/' \
  --include='package.json' \
  --include='bun.lockb' \
  --exclude='*' \
  "${B_CURRENT}" "${C_OUTPUT}"
USER root:root
# Devbox session end

FROM busybox AS project_manifest

COPY --from=project_manifest__base /workspace/outputs/project_manifest__base /export

FROM base_devbox AS install_modules__base

ARG B_CURRENT=/workspace/current
ARG B_INPUTS_ROOT=/workspace/inputs
ARG B_OUTPUTS_ROOT=/workspace/outputs
ARG C_OUTPUT="${B_OUTPUTS_ROOT}/install_modules__base"

RUN mkdir -p \
  "${B_CURRENT}" \
  "${B_INPUTS_ROOT}" \
  "${B_OUTPUTS_ROOT}" \
  "${C_OUTPUT}"

WORKDIR "${B_CURRENT}"

COPY --from=project_manifest /export "${B_INPUTS_ROOT}/project_manifest"

# Fix permissions start
RUN chown -R ${DEVBOX_USER}:${DEVBOX_USER} /workspace
# Fix permissions end

# Devbox session start
USER ${DEVBOX_USER}:${DEVBOX_USER}
RUN devbox run -- bash -c "\
    cd /workspace/current \
    && bun install --frozen-lockfile \
    && mv node_modules \"${C_OUTPUT}\"/node_modules.dev \
    && bun install --frozen-lockfile --production \
    && mv node_modules \"${C_OUTPUT}\"/node_modules.prod \
  "
USER root:root
# Devbox session end

FROM busybox AS install_modules

COPY --from=install_modules__base /workspace/outputs/install_modules__base /export

FROM base_devbox AS w3yz__base

ARG B_CURRENT=/workspace/current
ARG B_INPUTS_ROOT=/workspace/inputs
ARG B_OUTPUTS_ROOT=/workspace/outputs
ARG C_OUTPUT="${B_OUTPUTS_ROOT}/w3yz"

RUN mkdir -p \
  "${C_OUTPUT}"

ARG ROOT_DOMAIN
ARG SHOP_NAME
ARG MONGO_PORT
ARG MY_PERSONAL_MY_PERSONAL_GITHUB_TOKEN

ARG NODE_ENV=production
ARG SHOP_DOMAIN="${SHOP_NAME}.${ROOT_DOMAIN}"
ARG NEXT_PUBLIC_URL="https://${SHOP_NAME}.${ROOT_DOMAIN}"
ARG NEXT_PUBLIC_ECOM_API_URL="https://api.${SHOP_NAME}.${ROOT_DOMAIN}/graphql/"
ARG NEXT_PUBLIC_ECOM_NAME="${SHOP_NAME}"
ARG NEXT_PUBLIC_CMS_BASE_URL="https://${SHOP_NAME}.${ROOT_DOMAIN}"
ARG NEXTAUTH_SECRET="change-me"
ARG MONGODB_URI="mongodb://${SHOP_DOMAIN}:${MONGO_PORT}/${SHOP_NAME}"
ARG GITHUB_OWNER=w3yz-phoenix
ARG GITHUB_REPO=live
ARG GITHUB_BRANCH=main
ARG GITHUB_PERSONAL_ACCESS_TOKEN="${MY_PERSONAL_MY_PERSONAL_GITHUB_TOKEN}"
ARG TINA_PUBLIC_IS_LOCAL="false"
ARG NEXT_PUBLIC_TINA_IS_LOCAL="false"

COPY --from=install_modules /export/node_modules.dev "${B_INPUTS_ROOT}/install_modules/node_modules.dev"
COPY --from=install_modules /export/node_modules.prod "${B_INPUTS_ROOT}/install_modules/node_modules.prod"

# Fix permissions start
RUN chown -R ${DEVBOX_USER}:${DEVBOX_USER} /workspace
# Fix permissions end

# Devbox session start
USER ${DEVBOX_USER}:${DEVBOX_USER}
RUN devbox run -- bash -c "\
  cd /workspace/current \
  && rm -rf ./node_modules \
  && mv \"${B_INPUTS_ROOT}/install_modules/node_modules.dev\" ./node_modules \
  && bun install \
  && task ecom:generate -f \
  && task tinacms:build -f \
  && task cms:generate -f \
  && task storefront:build -f \
  "

# Devbox session end
USER root:root

RUN cd /workspace/current/apps/storefront \
  && mkdir -p /export/storefront \
  && mv .next /export/storefront \
  && mv public /export/storefront \
  && mv package.json /export/storefront

RUN cd /workspace/current/apps/tinacms \
  && mkdir -p /export/tinacms \
  && mv .next /export/tinacms \
  && mv public /export/tinacms \
  && mv content /export/tinacms \
  && mv package.json /export/tinacms

RUN rm -rf /workspace

FROM oven/bun:1-alpine AS storefront__release

COPY --from=w3yz__base /export/storefront /app
COPY --from=install_modules /export/node_modules.prod /app/node_modules

ARG ROOT_DOMAIN
ARG SHOP_NAME
ARG MONGO_PORT
ARG MY_PERSONAL_MY_PERSONAL_GITHUB_TOKEN

ENV ROOT_DOMAIN=${ROOT_DOMAIN}
ENV SHOP_NAME=${SHOP_NAME}

ENV NODE_ENV=production
ENV SHOP_DOMAIN="${SHOP_NAME}.${ROOT_DOMAIN}"
ENV NEXT_PUBLIC_URL="https://${SHOP_NAME}.${ROOT_DOMAIN}"
ENV NEXT_PUBLIC_ECOM_API_URL="https://api.${SHOP_NAME}.${ROOT_DOMAIN}/graphql/"
ENV NEXT_PUBLIC_ECOM_NAME="${SHOP_NAME}"
ENV NEXT_PUBLIC_CMS_BASE_URL="https://${SHOP_NAME}.${ROOT_DOMAIN}"
ENV NEXTAUTH_SECRET="change-me"
ENV MONGODB_URI="mongodb://${SHOP_DOMAIN}:${MONGO_PORT}/${SHOP_NAME}"
ENV GITHUB_OWNER=w3yz-phoenix
ENV GITHUB_REPO=live
ENV GITHUB_BRANCH=main
ENV GITHUB_PERSONAL_ACCESS_TOKEN="${MY_PERSONAL_MY_PERSONAL_GITHUB_TOKEN}"
ENV TINA_PUBLIC_IS_LOCAL="false"
ENV NEXT_PUBLIC_TINA_IS_LOCAL="false"

USER bun
WORKDIR /app
CMD ["bun", "x", "next", "start"]

FROM oven/bun:1-alpine AS tinacms__release

COPY --from=w3yz__base /export/tinacms /app
COPY --from=install_modules /export/node_modules.prod /app/node_modules

ARG ROOT_DOMAIN
ARG SHOP_NAME
ARG MONGO_PORT
ARG MY_PERSONAL_MY_PERSONAL_GITHUB_TOKEN

ENV ROOT_DOMAIN=${ROOT_DOMAIN}
ENV SHOP_NAME=${SHOP_NAME}

ENV NODE_ENV=production
ENV SHOP_DOMAIN="${SHOP_NAME}.${ROOT_DOMAIN}"
ENV NEXT_PUBLIC_URL="https://${SHOP_NAME}.${ROOT_DOMAIN}"
ENV NEXT_PUBLIC_ECOM_API_URL="https://api.${SHOP_NAME}.${ROOT_DOMAIN}/graphql/"
ENV NEXT_PUBLIC_ECOM_NAME="${SHOP_NAME}"
ENV NEXT_PUBLIC_CMS_BASE_URL="https://${SHOP_NAME}.${ROOT_DOMAIN}"
ENV NEXTAUTH_SECRET="change-me"
ENV MONGODB_URI="mongodb://${SHOP_DOMAIN}:${MONGO_PORT}/${SHOP_NAME}"
ENV GITHUB_OWNER=w3yz-phoenix
ENV GITHUB_REPO=live
ENV GITHUB_BRANCH=main
ENV GITHUB_PERSONAL_ACCESS_TOKEN="${MY_PERSONAL_MY_PERSONAL_GITHUB_TOKEN}"
ENV TINA_PUBLIC_IS_LOCAL="false"
ENV NEXT_PUBLIC_TINA_IS_LOCAL="false"

WORKDIR /app
CMD ["bun", "x", "next", "start"]
