---
author: "Jawed Salim"
---

Jenkins - Add Jenkins agent on k8s cluster
===

> {sub-ref}`today` | {sub-ref}`wordcount-minutes` min read


In this guide, we will setup **Jenkins agent** on a k8s cluster using docker image - `jenkins/inbound-agent`. This is an image for Jenkins agents using _TCP_ or _WebSockets_ to establish inbound connection to the **Jenkins primary**.

# Pre-requisites
- Jenkins Primary
- kubernetes >= 1.21

## Add agent node on Jenkins Primary

### Install Jenkins Kubernetes Plugin

- `Login` with admin user.
- Go to `Manage Jenkins` –> `Manage Plugins`, search for `Kubernetes` Plugin in the available tab and install it.

![manage-plugins](/_static/manage-plugins.png)

- and after that install the kubernetes plugin.

![kubernetes-plugin](/_static/kubernetes-plugin.png)

### Create a Kubernete Cloud Configuration

- Once installed, go to `Manage Jenkins` –> `Manage Node & Clouds`

![mange-nodes-n-clouds](/_static/mange-nodes-n-clouds.png)

- Click `Configure Clouds`

![configure-clouds](/_static/configure-clouds.png)

- `Add a new Cloud` -  select `Kubernetes`.

![add-new-cloud](/_static/add-new-cloud.png)

- Provide k8s cluster details

![k8s-details](/_static/k8s-details.png)

- Provide pod details

![pod-details](/_static/pod-details.png)

- Click on `Save` button.

All Done :)













