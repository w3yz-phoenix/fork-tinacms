# gitops-w3yz

Docker Login:

```bash
echo (gh auth token) | docker login ghcr.io -u yasinuslu --password-stdin
```

Render 01:

```bash
export ROOT_DOMAIN="rancher9.w3yz.dev";
export SHOP_NAME="shop1";
export MONGO_PORT="32508";
export MY_PERSONAL_GITHUB_TOKEN="$(gh auth token)";
skaffold run -p provision
```

Run 02:

```bash
export ROOT_DOMAIN="beta.w3yz.dev";
export SHOP_NAME="shop1";
export MONGO_PORT="32508";
export MY_PERSONAL_GITHUB_TOKEN="$(gh auth token)";
skaffold render -p release
```

Local Build:

```bash
export ROOT_DOMAIN="beta.w3yz.dev";
export SHOP_NAME="shop1";
export MONGO_PORT="32508";
export MY_PERSONAL_GITHUB_TOKEN="$(gh auth token)";
task build -f
docker build -t w3yz-release-test ./fast-build
docker run --rm -p 3000:3000 w3yz-release-test -w /apps/storefront
```
