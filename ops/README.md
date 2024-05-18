# gitops-w3yz

Docker Login:

```bash
echo (gh auth token) | docker login ghcr.io -u yasinuslu --password-stdin
```

Provision or Update:

```bash
export ROOT_DOMAIN="rancher9.w3yz.dev";
export SHOP_NAME="test1";
export NAMESPACE="w3yz-shop-$SHOP_NAME";
export NAMESPACE_EXISTS="$(kubectl get namespace $NAMESPACE 2> /dev/null)";
export MY_PERSONAL_GITHUB_TOKEN="$(gh auth token)";
if [ -z "$NAMESPACE_EXISTS" ]; then
  echo "Namespace does not exist, provisioning..."
  skaffold run -p provision
else
  echo "Namespace already exists running update..."
  skaffold deploy -i ghcr.io/w3yz-phoenix/w3yz:main -p release
  export MONGO_PORT="$(kubectl get -n w3yz-shop-$SHOP_NAME service ferretdb-exposed -o json | jq '.spec.ports[0].nodePort')";
fi;
```
