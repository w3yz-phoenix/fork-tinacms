# Rancher First Steps

## Cert Manager Tutorial

https://www.youtube.com/watch?v=IdvhywzV1oo
https://gist.github.com/dmancloud/0474dbfedaa7e3793099f68e96cab88f

Following this tutorial to use cert-manager in rancher

### Make sure the new domain is reachable

Make sure of the following:

```
65.109.169.241 rancher8.w3yz.dev
65.109.169.241 *.rancher8.w3yz.dev
```

Then make sure your SSH is working

```bash
ssh-keygen -R rancher8.w3yz.dev
ssh-keygen -R 65.21.52.120
ssh root@rancher8.w3yz.dev
```

[Dashboard](https://dash.rancher8.w3yz.dev)

### Install required tools

```bash
curl -sfL https://get.rke2.io | sh -
systemctl enable rke2-server.service
systemctl start rke2-server.service
```

### Make configurations and watch the pods

```bash
snap install kubectl --classic
snap install helm --classic
mkdir ~/.kube
cp /etc/rancher/rke2/rke2.yaml ~/.kube/config
chown $USER:$USER ~/.kube/config
chmod 400 ~/.kube/config
watch kubectl get pods -A
```

Then open up another terminal tab and continue:

```bash
ssh root@rancher8.w3yz.dev
```

### Install cert-manager

```bash
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm upgrade --install cert-manager jetstack/cert-manager  --namespace cert-manager --create-namespace --set installCRDs=true
```

### Create Cluster Issuer

For Staging Environment:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
spec:
  acme:
    # Staging environment URL
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    email: project@w3yz.com  # Replace with your email address
    privateKeySecretRef:
      name: letsencrypt-staging-private-key
    solvers:
    - http01:
        ingress:
          class: nginx
EOF
```

For Production Environment:

```bash
cat <<EOF | kubectl apply -f -
# Save this as cluster-issuer.yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: project@w3yz.com
    privateKeySecretRef:
      name: letsencrypt-prod-private-key
    solvers:
    - http01:
        ingress:
          class: nginx
EOF
```

### Install Rancher

```bash
kubectl create ns cattle-system
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo update
helm install rancher rancher-latest/rancher --namespace cattle-system --set hostname=rancher8.w3yz.dev --set bootstrapPassword=i-am-very-much-secure --set ingress.tls.source=letsEncrypt --set letsEncrypt.email=project@w3yz.com --set letsEncrypt.ingress.class=nginx
kubectl -n cattle-system rollout status deploy/rancher
```

> Note: You might need to double check your password

```bash
echo https://rancher8.w3yz.dev/dashboard/?setup=$(kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}')
```
