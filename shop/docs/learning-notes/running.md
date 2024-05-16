```bash
echo (gh auth token) | docker login ghcr.io -u yasinuslu --password-stdin
```

```bash
export GITHUB_TOKEN=(gh auth token);
export SHOP_NAME="puledro";
kubectl -n "w3yz-shop-$SHOP_NAME" delete deployment storefront;
skaffold render -p shop | kubectl apply -f -;
```
