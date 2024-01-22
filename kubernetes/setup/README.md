# Kubernetes Setup


## Prerequisite

```bash
export STACK_NAME=example-stack

export KUBECONFIG=~/.kube/$STACK_NAME-kubeconfig.yaml
```

- Check if kubectl is working

```bash
kubectl version
```

- Check kubernetes cluster in use

```bash
kubectl config current-context
```

- Get cluster info

```bash
kubectl cluster-info
```

- List nodes

```bash
kubectl get nodes
```


-------------


## Setup Helm

- Client Setup (Mac)

```bash
brew install kubernetes-helm
```

- Server Setup (Depriciated, newer versions >3 dont need it)


-------------


## Deploy Nginx Ingress Controller

Ref: setup-ingress-controller-nginx.md


-------------


## Deploy Cert Manager

Ref: setup-cert-manager.md


-------------

