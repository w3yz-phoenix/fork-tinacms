# Install longhorn

## With Helm

```bash
helm repo add longhorn https://charts.longhorn.io
helm repo update
```

## With Argo

Make sure you are using bash

```bash
argocd login --core
```

Install longhorn

```bash
cat <<EOF | kubectl -n argocd apply -f -
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: longhorn
  namespace: argocd
spec:
  syncPolicy:
    syncOptions:
      - CreateNamespace=true
  project: default
  sources:
    - chart: longhorn
      repoURL: https://charts.longhorn.io/
      targetRevision: v1.6.1 # Replace with the Longhorn version you'd like to install or upgrade to
      helm:
        values: |
          preUpgradeChecker:
            jobEnabled: false
  destination:
    server: https://kubernetes.default.svc
    namespace: longhorn-system
EOF
```

Sync longhorn

```bash
argocd app sync longhorn
```

```bash
kubectl -n longhorn-system get pod
```

## Next Steps

- Configure ingress and access UI
- https://longhorn.io/docs/1.6.1/deploy/accessing-the-ui/longhorn-ingress/