Install Jenkins with Helm v3
===

A typical Jenkins deployment consists of a controller node and, optionally, one or more agents. To simplify the deployment of Jenkins, we’ll use [Helm](https://helm.sh/) to deploy Jenkins. Helm is a package manager for Kubernetes and its package format is called a chart. Many community-developed charts are available on [GitHub](https://github.com/helm/charts).

## Prerequisites

### Helm command line interface

To install Helm CLI, follow the instructions from the [Installing Helm](https://helm.sh/docs/intro/install/) page.

## Configure the Jenkins Repo

```
helm repo add jenkins https://charts.jenkins.io
helm repo update
```

The helm charts in the Jenkins repo can be listed with the command:

```
helm search repo jenkinsci

NAME             	CHART VERSION	APP VERSION	DESCRIPTION
jenkinsci/jenkins	3.11.3       	2.319.2    	Jenkins - Build great things at any scale! The ...
```

## Create a namespace

A distinct namespace provides an additional layer of isolation and more control over the continuous integration environment. Create a namespace for the Jenkins deployment by typing the following command on your terminal:

```
kubectl create namespace jenkins
```

Use the following command to list existing namespaces:

```
kubectl get namespaces
```

The output confirms that the jenkins namespace was created successfully.

```
NAME              STATUS   AGE
default           Active   50m
jenkins           Active   30s
kube-node-lease   Active   50m
kube-public       Active   50m
kube-system       Active   50m
```

## Install Jenkins

We will deploy Jenkins including the Jenkins Kubernetes plugin. See the [official chart](https://github.com/jenkinsci/helm-charts/tree/main/charts/jenkins) for more details.

**Customize the chart before installing**

Paste the content from https://raw.githubusercontent.com/jenkinsci/helm-charts/main/charts/jenkins/values.yaml into a YAML formatted file called `values.yaml` (One is already exists in this directory).

The `values.yaml` is used as a template to provide values that are necessary for setup.

**Open the `values.yaml` file in your favourite text editor and modify the following:**

- You may change the service type, For minikube, set this to `NodePort`, elsewhere use `LoadBalancer`. Use `ClusterIP` if your setup includes ingress controller.

```
serviceType: ClusterIP
```

- Enable the ingress if your setup includes ingress controller.

```
ingress:
  enabled: true
  paths:
    - path: /
      pathType: Prefix
      backend:
        service:
          name: jenkins
          port:
            number: 8080
  # Use below config for Kubernetes <= v1.14+
  # - path: /
  #   backend:
  #     serviceName: ssl-redirect
  #     servicePort: use-annotation

  # For Kubernetes v1.14+, use 'networking.k8s.io/v1beta1'
  # For Kubernetes v1.19+, use 'networking.k8s.io/v1'
  apiVersion: "networking.k8s.io/v1"
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    # See - https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/
  hostName:
  tls:
  # - secretName: jenkins.cluster.local
  #   hosts:
  #     - jenkins.cluster.local
```

Now you can install Jenkins by running the `helm install` command and passing it the following arguments:

- The name of the release `jenkins`
- The name of the chart `jenkinsci/jenkins`
- The `-n` flag with the name of your namespace `jenkins`
- The `-f` flag with the YAML file with overrides `values.yaml`

```
helm install [RELEASE_NAME] [CHART_NAME] [flags]
```

Run

```
helm install jenkins jenkinsci/jenkins -n jenkins -f values.yaml
```

This outputs something similar to the following:

```
NAME: jenkins
LAST DEPLOYED: Wed Feb 02 11:13:10 2022
NAMESPACE: jenkins
STATUS: deployed
REVISION: 1
```

Enter the following command to inspect the status of your Pod:

```
kubectl get pods -n jenkins
```

Once Jenkins is installed, the status should be set to Running as in the following output:

```
kubectl get pods -n jenkins

NAME                       READY   STATUS    RESTARTS   AGE
jenkins-645fbf58d6-6xfvj   1/1     Running   0          2m
```

## Post-instalation steps

- Get your 'admin' user password by running:

```
jsonpath="{.data.jenkins-admin-password}"
secret=$(kubectl get secret -n jenkins jenkins -o jsonpath=$jsonpath)
echo $(echo $secret | base64 --decode)
```

- Get the Jenkins URL to visit by running these commands in the same shell:

```
jsonpath="{.spec.ports[0].nodePort}"
NODE_PORT=$(kubectl get -n jenkins -o jsonpath=$jsonpath services jenkins)
jsonpath="{.items[0].status.addresses[0].address}"
NODE_IP=$(kubectl get nodes -n jenkins -o jsonpath=$jsonpath)
echo http://$NODE_IP:$NODE_PORT/login
```

- Login with the password from first step and the username: `admin`
- Use Jenkins Configuration as Code by specifying configScripts in your `values.yaml` file. See the [configuration as code documentation](https://plugins.jenkins.io/configuration-as-code) and [examples](https://github.com/jenkinsci/configuration-as-code-plugin/tree/master/demos).


## List the Jenkins releases

Run the below command to list releases

```
helm list -n jenkins

NAME   	NAMESPACE	REVISION	UPDATED                             	STATUS  	CHART         	APP VERSION
jenkins	jenkins  	2       	2022-02-02 15:23:28.523159 +0530 IST	deployed	jenkins-3.11.3	2.319.2
```

## Uninstall Chart

```
helm uninstall jenkins
```

> This removes all the Kubernetes components associated with the chart and deletes the release.

## Upgrade Chart

```
helm upgrade [RELEASE_NAME] jenkinsci/jenkins [flags]
```

```
helm upgrade  jenkins jenkinsci/jenkins -n jenkins -f values.yaml
```
