# Kuberentes Auth

**Ref:**
- https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/

## Prerequisite

- Kustomize


## Add a user for auth and list/view resources accross cluster

- Create base service account for user in `bases/service-account.yaml`

- There are 3 roles

  - developer-view
  - developer-view-exec
  - developer-edit

- Add rolebinding the same user to cluster view permissions in file `bases/cluster-rolebinding.yaml`

- Apply the configuration

```bash
cd bases

kubectl apply -k .
```


## Add the user to allow specific access to specific namespace

(Adding user to debug namespace in staging environment infra)

- To provide access for debug namesapce, add user rolebinding in `staging/debug.yaml`

```bash
cd staging
kubectl apply -f debug.yaml
```


## Generate config for user

- export config file

```bash
./generate_auth.sh <user_name>
```

e.g.

```bash
./generate_auth.sh firstname1.lastname2
```
