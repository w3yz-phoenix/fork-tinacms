# gitops-w3yz

Docker Login:

```bash
echo (gh auth token) | docker login ghcr.io -u yasinuslu --password-stdin
```

Provision or Update:

```bash
export MY_PERSONAL_GITHUB_TOKEN="$(gh auth token)";
export ROOT_DOMAIN="beta.w3yz.dev";
export SHOP_NAME="hadi-lan";
export NAMESPACE="w3yz-shop-$SHOP_NAME";

docker login https://ghcr.io -u yasinuslu -p "$MY_PERSONAL_GITHUB_TOKEN";
kubectl -n "$NAMESPACE" create secret docker-registry ghcr-secret --docker-server=https://ghcr.io --docker-username=yasinuslu --docker-password="$MY_PERSONAL_GITHUB_TOKEN" --docker-email="nepjua@gmail.com";

export NAMESPACE_EXISTS="$(kubectl get namespace $NAMESPACE 2> /dev/null)";
if [ -z "$NAMESPACE_EXISTS" ]; then
  echo "Namespace does not exist, provisioning..."
  skaffold run -p provision
else
  echo "Namespace already exists running update..."
  export MONGO_PORT="$(kubectl get -n w3yz-shop-$SHOP_NAME service ferretdb-exposed -o json | jq '.spec.ports[0].nodePort')";
  skaffold deploy -i ghcr.io/w3yz-phoenix/w3yz:main -p release
fi;
```
