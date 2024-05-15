# Deploy a service and expose it with a domain

## Create an nginx deployment

Deploy an nginx deployment and expose it as a service

```bash
kubectl create deployment my-demo-2 --image=nginx
kubectl expose deployment my-demo-2 --port=80 --type=ClusterIP
```

Create an ingress for the service

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-demo-2-ingress
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - my-demo-2.rancher7.w3yz.dev
    secretName: my-demo-2-tls
  rules:
  - host: my-demo-2.rancher7.w3yz.dev
    http:
      paths:
      - pathType: Prefix
        path: "/"
        backend:
          service:
            name: my-demo-2
            port:
              number: 80
EOF
```

Create a certificate for the ingress

```bash
cat <<EOF | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: my-demo-2-certificate
  namespace: default
spec:
  secretName: my-demo-2-tls
  issuerRef:
    name: letsencrypt-prod  # Change to letsencrypt-staging if using the staging environment
    kind: ClusterIssuer
  dnsNames:
  - my-demo-2.rancher7.w3yz.dev
EOF
```
