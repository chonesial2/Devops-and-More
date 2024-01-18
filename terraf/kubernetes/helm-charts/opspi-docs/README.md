OpsPi Docs
====

## Prerequisites

- [Helm CLI - helm 3](https://helm.sh/docs/intro/install/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)

## Installation

### Create a namespace

- Create a namespace for the `Opspi-docs` deployment by typing the following command on your terminal:

```
kubectl create namespace opspi
```

- Use the following command to list existing namespaces:

```
kubectl get namespaces
```

- The output confirms that the `opspi` namespace was created successfully.

```
NAME              STATUS   AGE
default           Active   50m
kube-node-lease   Active   50m
kube-public       Active   50m
kube-system       Active   50m
opspi             Active   30s
...
```

### Create a Docker registry secret

To pull an image from a private docker registry. You need

- The Docker server to use is a domain such `registry.gitlab.com`, `gcr.io` etc.
- The username is your account username.
- The password is a specific docker registry password or any other kind of token.
  You need to check the documentation of your registry provider for the exact details.
  For the Gitlab, refer - https://docs.gitlab.com/ee/user/packages/container_registry/


> Be sure to create the Secret in the namespace in which your application will run. Pull secrets are specific to a namespace. If you want to deploy to multiple namespaces you need to create a secret for each one of them.


```
export DOCKER_REGISTRY_SERVER=registry.gitlab.com
export DOCKER_USER=registery_user
export DOCKER_PASSWORD=registry_token_or_pass
export DOCKER_EMAIL=registery_email

kubectl create secret docker-registry regcred \
        --docker-server=$DOCKER_REGISTRY_SERVER  \
        --docker-username=$DOCKER_USER  \
        --docker-password=$DOCKER_PASSWORD  \
        --docker-email=$DOCKER_EMAIL  -n opspi
```

### Customize the chart before installing

Open the `values.yaml` file in your favourite text editor and modify the following:

- Replica count.
- Image name and tag.
- Service type
- Enable/disable the Ingress
- Host Name and etc.

### Deploy the app on cluster

- Run the following command tom deploy the app on k8s cluster

```
helm install opspi-docs ./ -f values.yaml -n [your-namespace]

NAME: opspi-docs
LAST DEPLOYED: Sun Feb  6 22:24:53 2022
NAMESPACE: opspi
STATUS: deployed
REVISION: 1
NOTES:
1. Get the application URL by running these commands:
    Visit https://docs.apps.opspi.com

```

- List Releases

```
helm list -n opspi

NAME      	NAMESPACE	REVISION	UPDATED                            	STATUS  	CHART           	APP VERSION
opspi-docs	opspi    	1       	2022-02-06 22:24:53.44907 +0530 IST	deployed	opspi-docs-0.1.0	1.16.0
```
