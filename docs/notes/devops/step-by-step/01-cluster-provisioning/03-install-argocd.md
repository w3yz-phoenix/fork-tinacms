# Argocd

This tutorial will guide you through the installation of ArgoCD on a Kubernetes cluster.

It is heavily inspired by this amazing tutorial

- [ArgoCD Installation on Kubernetes : Step-by-Step Guide](https://www.youtube.com/watch?v=fBd_tz6BALU)
- [Gist](https://gist.github.com/dmancloud/7a024aa0e47fd39bd0db6e80a4aae842)
- [Tutorial Repository](https://github.com/dmancloud/argocd-tutorial)
- [ArgoCD Documentation](https://argo-cd.readthedocs.io/en/stable/getting_started/)

## Prerequisites

- [A Kubernetes cluster](../step-by-step/01-install-rancher.md)

We will assume that you have a Kubernetes cluster up and running.
And you can connect to the server with ssh:

```bash
ssh root@rancher9.w3yz.dev
```

## Setting up ArgoCD

### Install ArgoCD

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### Create Ingress

```bash
cat <<EOF | kubectl -n argocd apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd-server-ingress
  namespace: argocd
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
    nginx.ingress.kubernetes.io/ssl-passthrough: "true"
    # If you encounter a redirect loop or are getting a 307 response code
    # then you need to force the nginx ingress to connect to the backend using HTTPS.
    #
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
spec:
  ingressClassName: nginx
  rules:
  - host: argocd.rancher9.w3yz.dev
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: argocd-server
            port:
              name: https
  tls:
  - hosts:
    - argocd.rancher9.w3yz.dev
    secretName: argocd-server-tls # as expected by argocd-server
EOF
```

### Create Certificate

```bash
cat <<EOF | kubectl -n argocd apply -f -
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: argocd-server-certificate
  namespace: argocd
spec:
  secretName: argocd-server-tls
  issuerRef:
    name: letsencrypt-prod  # Change to letsencrypt-staging if using the staging environment
    kind: ClusterIssuer
  dnsNames:
  - argocd.rancher9.w3yz.dev
EOF
```

### Access ArgoCD

Acquire password

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Then open up your browser and go to [https://argocd.rancher9.w3yz.dev](https://argocd.rancher9.w3yz.dev)

- Username: admin
- Password: sRkBZR4ORr28at0t

### Install argocd CLI

```bash
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64
```

### Install argocd CLI arm64

```bash
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-arm64
sudo install -m 555 argocd-linux-arm64 /usr/local/bin/argocd
rm argocd-linux-arm64
```

### Connect Repository

```bash
argocd repo add git@github.com:w3yz-phoenix/gitops-w3yz --ssh-private-key-path ~/Downloads/id_ed25519
```
