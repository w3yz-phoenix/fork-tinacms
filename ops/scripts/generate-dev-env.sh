#!/usr/bin/env bash

# Generates a .env file for development based on the current k8s cluster state
# If the user is not logged in to GitHub, it ignores the GITHUB_PERSONAL_ACCESS_TOKEN
# If the user does not have any kubectl context, it will ignore the MONGODB_URI

generateDevEnv() {
  export NODE_ENV=development

  export SHOP_DOMAIN="${NEXT_PUBLIC_SHOP_NAME}.${NEXT_PUBLIC_ROOT_DOMAIN}"
  export NAMESPACE="w3yz-shop-${NEXT_PUBLIC_SHOP_NAME}"

  local nodeName=$(kubectl get nodes -o json 2> /dev/null | jq '.items[0].metadata.name')
  local githubToken=$(gh auth token 2> /dev/null)

  if [ -z "$githubToken" ]; then
    echo "No GitHub token found. Skipping GITHUB_PERSONAL_ACCESS_TOKEN"
    export MY_PERSONAL_GITHUB_TOKEN=""
  else
    MY_PERSONAL_GITHUB_TOKEN="$(gh auth token)"
    export MY_PERSONAL_GITHUB_TOKEN="${MY_PERSONAL_GITHUB_TOKEN}"
  fi

  if [ -z "$nodeName" ]; then
    echo "No k8s context found. Skipping MONGODB_URI"
    export NEXT_PUBLIC_MONGO_PORT=""
    export MONGODB_URI=""
  else
    NEXT_PUBLIC_MONGO_PORT="$(kubectl get -n "${NAMESPACE}" service ferretdb-exposed -o json | jq '.spec.ports[0].nodePort')"
    export NEXT_PUBLIC_MONGO_PORT="${NEXT_PUBLIC_MONGO_PORT}"
    export MONGODB_URI="mongodb://${SHOP_DOMAIN}:${NEXT_PUBLIC_MONGO_PORT}/${NEXT_PUBLIC_SHOP_NAME}"
  fi

  export NEXT_PUBLIC_URL="https://localhost:3000/"
  export NEXT_PUBLIC_CMS_BASE_URL="http://localhost:3000/"
  export NEXT_PUBLIC_ECOM_API_URL="https://api.${NEXT_PUBLIC_SHOP_NAME}.${NEXT_PUBLIC_ROOT_DOMAIN}/graphql/"
  export NEXT_PUBLIC_ECOM_NAME="${NEXT_PUBLIC_SHOP_NAME}"
  export NEXT_PUBLIC_SHOP_DOMAIN="${SHOP_DOMAIN}"
  export NEXTAUTH_SECRET="change-me"
  export GITHUB_OWNER=w3yz-phoenix
  export GITHUB_REPO=live
  export GITHUB_BRANCH=main
  export GITHUB_PERSONAL_ACCESS_TOKEN="${MY_PERSONAL_GITHUB_TOKEN}"
  export TINA_PUBLIC_IS_LOCAL="false"
  export NEXT_PUBLIC_TINA_IS_LOCAL="false"

  cat << EOF > .env
export NEXT_PUBLIC_SHOP_NAME="${NEXT_PUBLIC_SHOP_NAME}"
export NEXT_PUBLIC_ROOT_DOMAIN="${NEXT_PUBLIC_ROOT_DOMAIN}"

export SHOP_DOMAIN="${SHOP_DOMAIN}"
export NAMESPACE="${NAMESPACE}"
export MY_PERSONAL_GITHUB_TOKEN="${MY_PERSONAL_GITHUB_TOKEN}"
export NEXT_PUBLIC_MONGO_PORT="${NEXT_PUBLIC_MONGO_PORT}"
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
}

generateDevEnv
