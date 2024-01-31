# Ingress Controller

**Ref:**
- https://kubernetes.github.io/ingress-nginx/deploy/


-------------


## Prerequisites

- Env var setup

```bash
export STACK_NAME=example-stack

export KUBECONFIG=~/.kube/$STACK_NAME-kubeconfig.yaml
```

- Kubernetes 1.16+
- Helm v3 (https://helm.sh/docs/intro/install/)


-------------


## Setup ingress controller

- Create namespace

```bash
kubectl create namespace ingress-$STACK_NAME
```

- Install using helm

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install ingress-nginx \
    ingress-nginx/ingress-nginx \
    --namespace ingress-$STACK_NAME \
    --set controller.replicaCount=2 \
    --set nodeSelector."beta.kubernetes.io/os"=linux
```

- Detect installed version

```bash
POD_NAME=$(kubectl get pods -l app.kubernetes.io/name=ingress-nginx -o jsonpath='{.items[0].metadata.name}' -n ingress-$STACK_NAME)
kubectl exec -it $POD_NAME -n ingress-$STACK_NAME -- /nginx-ingress-controller --version
```

- To get the public IP address, use the kubectl get service command. It takes a few minutes for the IP address to be assigned to the service.

```bash
kubectl get service -l app.kubernetes.io/name=ingress-nginx --namespace ingress-$STACK_NAME
```


-------------


## Setup DNS

- Point the DNS to service EXTERNAL-IP you got from above command

e.g.

`gw.example.com` =>  `1.2.3.4`

`api.example.com` =>  `gw.example.com`


------------------------


## Uninstall

```bash
helm uninstall ingress-nginx -n ingress-$STACK_NAME
helm uninstall ingress-nginx/ingress-nginx -n ingress-$STACK_NAME
```


------------------------

