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


## Setup Litmus Chaos

- Chaos operator

```bash
kubectl apply -f https://litmuschaos.github.io/litmus/litmus-operator-v1.13.0.yaml
```


-------------


## Verify if the ChaosOperator is running

```bash
kubectl get pods -n litmus

kubectl get crds | grep chaos

kubectl api-resources | grep chaos
```

-------------

## Create Namespace for your project

<!---
For example purpose nginx namespace has been used in all the yaml files
--->

```bash
kubectl create ns <your namespace>
```

### Create deployment in your namespace

- Nginx Example for reference

```bash
kubectl create deployment nginx --image nginx -n <your namespace>
```

## Install Chaos Experiments

```bash
kubectl apply -f https://hub.litmuschaos.io/api/chaos/1.13.0?file=charts/generic/experiments.yaml -n <your namespace>

kubectl get chaosexperiments -n <your namespace>

```

## Create Service Account

<!---
A service account should be created to allow chaosengine to run experiments in your application namespace. Following rbac files are provided in the repo run kubectl apply -f chaos-pod-delete-rbac.yaml to create one such account on your namespace. This serviceaccount has just enough permissions needed to run the pod-delete chaos experiment.
-->

```bash
kubectl apply -f chaos-pod-delete-rbac.yaml -n <your namespace>
```

-------------

## Annotate your application

<!--- 
Your application has to be annotated with litmuschaos.io/chaos="true". As a security measure, and also as a means to reduce blast radius the ChaosOperator checks for this annotation before invoking chaos experiment(s) on the application. Replace nginx with the name of your deployment.
--->

```bash
kubectl annotate deploy/nginx litmuschaos.io/chaos="true" -n <your namespace>
```


-------------

## Prepare ChaosEngine

<!--- 
ChaosEngine connects the application instance to a Chaos Experiment. Copy the following YAML snippet into a file called chaosengine.yaml and update the values of applabel , appns, appkind and experiments as per your choice. Change the chaosServiceAccount to the name of service account created in above previous steps, refer chaos-engine yaml files in repo
--->

```bash
kubectl apply -f chaosengine.yaml -n <your namespace>
```
## Observe Chaos results

<!--- 
Describe the ChaosResult CR to know the status of each experiment. The status.verdict is set to Awaited when the experiment is in progress, eventually changing to either Pass or Fail.

NOTE: ChaosResult CR name will be <chaos-engine-name>-<chaos-experiment-name>
--->

```bash
kubectl describe chaosresult nginx-chaos-pod-delete -n <your namespace>
```

## Uninstallation

<!--- 
Firstly, delete any active ChaosEngines on the cluster, followed by the deletion of the Operator manifest.
--->
```bash
kubectl delete chaosengine --all -n <your namespace>

kubectl delete -f https://litmuschaos.github.io/litmus/litmus-operator-v1.13.0.yaml
```