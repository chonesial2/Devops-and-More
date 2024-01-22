# Cert Manager


-------------


## Prerequisites

- Env var setup

```bash
export KUBECONFIG=~/.kube/client_name-kubeconfig.yaml
export STACK_NAME=client_name

export CERT_EMAIL=client.ops@example.com
```

- Kubernetes 1.16+
- Helm v3


-------------


## Cert Manager

```bash
helm repo add jetstack https://charts.jetstack.io
helm repo update
```

- Install CRDs 

```bash
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.9.1 \
  --set installCRDs=true
```


- Verify the installation

```bash
kubectl get pods --namespace cert-manager
```



**Ref:**
- https://cert-manager.io/docs/configuration/acme/


- Install cluster issuer


```bash
cat <<EOF | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
  namespace: ingress-$STACK_NAME
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: $CERT_EMAIL
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - selector: {}
      http01:
        ingress:
          class: nginx
EOF
```

- Verify

```bash
kubectl get ClusterIssuer -n ingress-$STACK_NAME
```


-------------


## Upgrade cert manager

**Ref:**
- https://cert-manager.io/docs/installation/upgrading/


-------------

## Uninstall cert manager


```bash
kubectl get Issuers,ClusterIssuers,Certificates,CertificateRequests,Orders,Challenges --all-namespaces
```

```bash
kubectl delete -f https://github.com/jetstack/cert-manager/releases/download/v1.1.0/cert-manager.yaml
```


-------------


## Troubleshoot

- https://cert-manager.io/docs/faq/troubleshooting/
- https://cert-manager.io/docs/faq/acme/


- List all resources

```bash
kubectl get certificate,certificaterequest,order,challenges -n <namespace>
```

-------------

