#!/usr/bin/env bash
set -eux

CURRENT_USER=$1
K8S_CLUSTER_NAME=$(kubectl config view --minify  -o jsonpath='{.clusters[0].name}')
K8S_CLUSTER_SERVER=$(kubectl config view --minify  -o jsonpath='{.clusters[0].cluster.server}')
K8S_TOKEN_NAME=$(kubectl get sa -n kube-system ${CURRENT_USER} -o jsonpath='{.secrets[0].name}')
K8S_USER_TOKEN=$(kubectl get secret -n kube-system ${K8S_TOKEN_NAME} -ojsonpath='{.data.token}' | base64 --decode)
K8S_CERTIFICATE=$(kubectl get secret -n kube-system ${K8S_TOKEN_NAME} -ojsonpath='{.data.ca\.crt}')

# cat << EOF > ${CURRENT_USER}.${K8S_CLUSTER_NAME}.yaml
cat << EOF > ${CURRENT_USER}.yaml
apiVersion: v1
kind: Config
clusters:
- name: ${K8S_CLUSTER_NAME}
  cluster:
      server: "${K8S_CLUSTER_SERVER}"
      certificate-authority-data: ${K8S_CERTIFICATE}
contexts:
- name: ${K8S_CLUSTER_NAME}
  context:
    cluster: ${K8S_CLUSTER_NAME}
    user: ${K8S_CLUSTER_NAME}
current-context: ${K8S_CLUSTER_NAME}
users:
- name: ${K8S_CLUSTER_NAME}
  user:
    token: "${K8S_USER_TOKEN}"
EOF
