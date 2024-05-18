#!/usr/bin/env bash

export SHOP_DOMAIN="${SHOP_NAME}.${ROOT_DOMAIN}"
export NAMESPACE="w3yz-shop-${SHOP_NAME}"
MY_PERSONAL_GITHUB_TOKEN="$(gh auth token)"
export MY_PERSONAL_GITHUB_TOKEN="${MY_PERSONAL_GITHUB_TOKEN}"
MONGO_PORT="$(kubectl get -n "${NAMESPACE}" service ferretdb-exposed -o json | jq '.spec.ports[0].nodePort')"
export MONGO_PORT="${MONGO_PORT}"

export NODE_ENV=development
export NEXT_PUBLIC_URL="https://${SHOP_NAME}.${ROOT_DOMAIN}"
export NEXT_PUBLIC_ECOM_API_URL="https://api.${SHOP_NAME}.${ROOT_DOMAIN}/graphql/"
export NEXT_PUBLIC_ECOM_NAME="${SHOP_NAME}"
export NEXT_PUBLIC_SHOP_DOMAIN="${SHOP_DOMAIN}"
export NEXT_PUBLIC_CMS_BASE_URL="https://${SHOP_NAME}.${ROOT_DOMAIN}"
export NEXTAUTH_SECRET="change-me"
export MONGODB_URI="mongodb://${SHOP_DOMAIN}:${MONGO_PORT}/${SHOP_NAME}"
export GITHUB_OWNER=w3yz-phoenix
export GITHUB_REPO=live
export GITHUB_BRANCH=main
export GITHUB_PERSONAL_ACCESS_TOKEN="${MY_PERSONAL_GITHUB_TOKEN}"
export TINA_PUBLIC_IS_LOCAL="false"
export NEXT_PUBLIC_TINA_IS_LOCAL="false"

cat << EOF > .env
export SHOP_NAME="${SHOP_NAME}"
export ROOT_DOMAIN="${ROOT_DOMAIN}"

export SHOP_DOMAIN="${SHOP_DOMAIN}"
export NAMESPACE="${NAMESPACE}"
export MY_PERSONAL_GITHUB_TOKEN="${MY_PERSONAL_GITHUB_TOKEN}"
export MONGO_PORT="${MONGO_PORT}"
export NODE_ENV="${NODE_ENV}"
export NEXT_PUBLIC_URL="${NEXT_PUBLIC_URL}"
export NEXT_PUBLIC_ECOM_API_URL="${NEXT_PUBLIC_ECOM_API_URL}"
export NEXT_PUBLIC_ECOM_NAME="${NEXT_PUBLIC_ECOM_NAME}"
export NEXT_PUBLIC_SHOP_DOMAIN="${NEXT_PUBLIC_SHOP_DOMAIN}"
export NEXT_PUBLIC_CMS_BASE_URL="${NEXT_PUBLIC_CMS_BASE_URL}"
export NEXTAUTH_SECRET="${NEXTAUTH_SECRET}"
export MONGODB_URI="${MONGODB_URI}"
export GITHUB_OWNER="${GITHUB_OWNER}"
export GITHUB_REPO="${GITHUB_REPO}"
export GITHUB_BRANCH="${GITHUB_BRANCH}"
export GITHUB_PERSONAL_ACCESS_TOKEN="${GITHUB_PERSONAL_ACCESS_TOKEN}"
export TINA_PUBLIC_IS_LOCAL="${TINA_PUBLIC_IS_LOCAL}"
export NEXT_PUBLIC_TINA_IS_LOCAL="${NEXT_PUBLIC_TINA_IS_LOCAL}"
EOF
