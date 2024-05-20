# gitops-w3yz

Docker Login:

```bash
echo (gh auth token) | docker login ghcr.io -u yasinuslu --password-stdin
```

Provision or Update:

```bash
export MY_PERSONAL_GITHUB_TOKEN="$(gh auth token)";
export NEXT_PUBLIC_ROOT_DOMAIN="beta.w3yz.dev";
export NEXT_PUBLIC_SHOP_NAME="hadi-lan";
export NAMESPACE="w3yz-shop-$NEXT_PUBLIC_SHOP_NAME";

skaffold deploy -i ghcr.io/w3yz-phoenix/w3yz:main -p release
```

Local Build:

```bash
export MY_PERSONAL_GITHUB_TOKEN="$(gh auth token)";
export NEXT_PUBLIC_ROOT_DOMAIN="beta.w3yz.dev";
export NEXT_PUBLIC_SHOP_NAME="hadi-lan";
export NAMESPACE="w3yz-shop-$NEXT_PUBLIC_SHOP_NAME";

export NAMESPACE_EXISTS="$(kubectl get namespace $NAMESPACE 2> /dev/null)";
if [ -z "$NAMESPACE_EXISTS" ]; then
  echo "Namespace does not exist, provisioning...";
  echo "Try again";
else
  echo "Namespace already exists running update..."
  export NEXT_PUBLIC_MONGO_PORT="$(kubectl get -n w3yz-shop-$NEXT_PUBLIC_SHOP_NAME service ferretdb-exposed -o json | jq '.spec.ports[0].nodePort')";
  task build -f
  docker build -t w3yz-release-test ./fast-build
  docker run -w /apps/storefront --rm -p 3000:3000 w3yz-release-test
fi;
```

Run Services:

```bash
export MY_PERSONAL_GITHUB_TOKEN="$(gh auth token)";
export NEXT_PUBLIC_ROOT_DOMAIN="beta.w3yz.dev";
export NEXT_PUBLIC_SHOP_NAME="hadi-lan";
export NAMESPACE="w3yz-shop-$NEXT_PUBLIC_SHOP_NAME";

export NEXT_PUBLIC_MONGO_PORT="$(kubectl get -n w3yz-shop-$NEXT_PUBLIC_SHOP_NAME service ferretdb-exposed -o json | jq '.spec.ports[0].nodePort')";

docker rm --force test-storefront
docker run --name=test-storefront -d -w /apps/storefront -p 3000:3000 w3yz-release-test \
  -e MY_PERSONAL_GITHUB_TOKEN="${MY_PERSONAL_GITHUB_TOKEN}" \
  -e NEXT_PUBLIC_ROOT_DOMAIN="${NEXT_PUBLIC_ROOT_DOMAIN}" \
  -e NEXT_PUBLIC_SHOP_NAME="${NEXT_PUBLIC_SHOP_NAME}" \
  -e NAMESPACE="${NAMESPACE}" \
  -e NEXT_PUBLIC_MONGO_PORT="${NEXT_PUBLIC_MONGO_PORT}" \
  -e NODE_ENV=production \
  -e SHOP_DOMAIN="${NEXT_PUBLIC_SHOP_NAME}.${NEXT_PUBLIC_ROOT_DOMAIN}" \
  -e NEXT_PUBLIC_URL="https://${NEXT_PUBLIC_SHOP_NAME}.${NEXT_PUBLIC_ROOT_DOMAIN}" \
  -e NEXT_PUBLIC_ECOM_API_URL="https://api.${NEXT_PUBLIC_SHOP_NAME}.${NEXT_PUBLIC_ROOT_DOMAIN}/graphql/" \
  -e NEXT_PUBLIC_ECOM_NAME="${NEXT_PUBLIC_SHOP_NAME}" \
  -e NEXT_PUBLIC_SHOP_DOMAIN="${SHOP_DOMAIN}" \
  -e NEXT_PUBLIC_CMS_BASE_URL="https://${NEXT_PUBLIC_SHOP_NAME}.${NEXT_PUBLIC_ROOT_DOMAIN}" \
  -e NEXTAUTH_SECRET="change-me" \
  -e MONGODB_URI="mongodb://${SHOP_DOMAIN}:${NEXT_PUBLIC_MONGO_PORT}/${NEXT_PUBLIC_SHOP_NAME}" \
  -e GITHUB_OWNER=w3yz-phoenix \
  -e GITHUB_REPO=live \
  -e GITHUB_BRANCH=main \
  -e GITHUB_PERSONAL_ACCESS_TOKEN="${MY_PERSONAL_GITHUB_TOKEN}" \
  -e TINA_PUBLIC_IS_LOCAL="false" \
  -e NEXT_PUBLIC_TINA_IS_LOCAL="false"

docker rm --force test-tinacms
docker run --name=test-tinacms -d -w /apps/tinacms -p 3200:3000 w3yz-release-test \
  -e MY_PERSONAL_GITHUB_TOKEN="${MY_PERSONAL_GITHUB_TOKEN}" \
  -e NEXT_PUBLIC_ROOT_DOMAIN="${NEXT_PUBLIC_ROOT_DOMAIN}" \
  -e NEXT_PUBLIC_SHOP_NAME="${NEXT_PUBLIC_SHOP_NAME}" \
  -e NAMESPACE="${NAMESPACE}" \
  -e NEXT_PUBLIC_MONGO_PORT="${NEXT_PUBLIC_MONGO_PORT}" \
  -e NODE_ENV=production \
  -e SHOP_DOMAIN="${NEXT_PUBLIC_SHOP_NAME}.${NEXT_PUBLIC_ROOT_DOMAIN}" \
  -e NEXT_PUBLIC_URL="https://${NEXT_PUBLIC_SHOP_NAME}.${NEXT_PUBLIC_ROOT_DOMAIN}" \
  -e NEXT_PUBLIC_ECOM_API_URL="https://api.${NEXT_PUBLIC_SHOP_NAME}.${NEXT_PUBLIC_ROOT_DOMAIN}/graphql/" \
  -e NEXT_PUBLIC_ECOM_NAME="${NEXT_PUBLIC_SHOP_NAME}" \
  -e NEXT_PUBLIC_SHOP_DOMAIN="${SHOP_DOMAIN}" \
  -e NEXT_PUBLIC_CMS_BASE_URL="https://${NEXT_PUBLIC_SHOP_NAME}.${NEXT_PUBLIC_ROOT_DOMAIN}" \
  -e NEXTAUTH_SECRET="change-me" \
  -e MONGODB_URI="mongodb://${SHOP_DOMAIN}:${NEXT_PUBLIC_MONGO_PORT}/${NEXT_PUBLIC_SHOP_NAME}" \
  -e GITHUB_OWNER=w3yz-phoenix \
  -e GITHUB_REPO=live \
  -e GITHUB_BRANCH=main \
  -e GITHUB_PERSONAL_ACCESS_TOKEN="${MY_PERSONAL_GITHUB_TOKEN}" \
  -e TINA_PUBLIC_IS_LOCAL="false" \
  -e NEXT_PUBLIC_TINA_IS_LOCAL="false"
```
