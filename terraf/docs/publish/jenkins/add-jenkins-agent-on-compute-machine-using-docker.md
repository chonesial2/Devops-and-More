---
author: "Jawed Salim"
---

Add Jenkins agent on compute machine using docker image
===

> {sub-ref}`today` | {sub-ref}`wordcount-minutes` min read

In this guide, we will setup **Jenkins agent** on a compute machine using docker image - `jenkins/inbound-agent`. This is an image for Jenkins agents using _TCP_ or _WebSockets_ to establish inbound connection to the **Jenkins primary**. This agent is powered by the Jenkins Remoting library, which version is being taken from the base Docker Agent image.

See [Jenkins Distributed builds](https://wiki.jenkins-ci.org/display/JENKINS/Distributed+builds) for more info.

## Pre-requisites
- Jenkins Primary
- [docker](https://docs.docker.com/engine/install/)

## Add agent node on Jenkins Primary using Jenkins UI

### Configure
- `Login` with admin user.
- Navigate to `Dashboard` --> `Manage Jenkins` --> `Manage Nodes and Clouds`

![mange-nodes-n-clouds](/_static/mange-nodes-n-clouds.png)

- Click on `+ New Node`
- Write `Node name` and select `Permanent Agent`

![add-new-node](/_static/add-new-node.png)

- Provide the required inputs like

![configure-node-part01](/_static/configure-node-part01.png)

  - `Name` - e.g. _compute-agent-01_
  - `Number of executors` - The maximum number of concurrent builds that Jenkins may perform on this node. Depends on CPU core and memory.
  - `Remote root directory` - An agent needs to have a directory dedicated to Jenkins. e.g. - `/var/jenkins` or `c:\jenkins`
  - `Labels` - Labels (or tags) are used to group multiple agents into one logical group.
. e.g. _compute-agent-01_
  - `Usage` - Use this node as much as possible

![configure-node-part02](/_static/configure-node-part02.png)

  - `Launch method` - Launch agent by connecting it to controller
  - `Internal data directory` - Defines a storage directory for the internal data. This directory will be created within the Remoting working directory. e.g. - _remoting_
  - `Use websocket` - _True_
  - `Availability` - Keep this agent online as much as possible

- Finally, click on `Save` button

### Status
**Now we will get following details on `Status` page of the above added agent.**

![agent-status](/_static/agent-status.png)

Connect agent to Jenkins one of these ways:
Run from agent command line:

```bash
java -jar agent.jar -jnlpUrl https://jenkins.example.com/computer/ComputeAgent01/jenkins-agent.jnlp -secret aaaaaaaaaabbbbbbbbbbbbbbcccccccccccccdddddddddddddddeeeeeeeeeeeefffff -workDir "/var/jenkins"
```

Run from agent command line, with the secret stored in a file:

```bash
echo aaaaaaaaaabbbbbbbbbbbbbbcccccccccccccdddddddddddddddeeeeeeeeeeeefffff > secret-file
java -jar agent.jar -jnlpUrl https://jenkins.example.com/computer/ComputeAgent01/jenkins-agent.jnlp -secret @secret-file -workDir "/var/jenkins"
```

Note down the `secret` and `agentName`

## Run Jenkins agent on compute machine inside docker container

- Create `.env` file

```bash
JENKINS_URL='https://jenkins.example.com'
JENKINS_SECRET='aaaaaaaaaabbbbbbbbbbbbbbcccccccccccccdddddddddddddddeeeeeeeeeeeefffff'
JENKINS_WEB_SOCKET=true
JENKINS_AGENT_NAME='ComputeAgent01'
```

- create `docker-compose.yaml` file

```yaml
version: '3.3'
services:
  jenkins_agent:
    image: registry.gitlab.com/stackexpress-public/apps/jenkins/inbound-agent:4.11.2-4
    container_name: jenkins_agent
    env_file:
      - .env
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock:ro"
    restart: unless-stopped
```

- Run `jenkins_agent` in container

```bash
docker-compose up
```

Output
```bash
Aug 02, 2022 2:53:08 AM hudson.remoting.jnlp.Main createEngine
INFO: Setting up agent: ComputeAgent01
Aug 02, 2022 2:53:08 AM hudson.remoting.jnlp.Main$CuiListener <init>
INFO: Jenkins agent is running in headless mode.
Aug 02, 2022 2:53:08 AM hudson.remoting.Engine startEngine
INFO: Using Remoting version: 4.11.2
Aug 02, 2022 2:53:08 AM hudson.remoting.Engine startEngine
WARNING: No Working Directory. Using the legacy JAR Cache location: /home/jenkins/.jenkins/cache/jars
Aug 02, 2022 2:53:10 AM hudson.remoting.jnlp.Main$CuiListener status
INFO: WebSocket connection open
Aug 02, 2022 2:53:10 AM hudson.remoting.jnlp.Main$CuiListener status
INFO: Connected
```

All done :)

## Add agent node on Jenkins Primary using Jenkins API

Required python package - [api4jenkins](https://pypi.org/project/api4jenkins/)

```sh
pip install api4jenkins
```
### Authenticate to Jenkins server

```sh
export JENKINS_ENDPOINT='http://127.0.0.1:8080/'
export JENKINS_USER='username'
export JENKINS_PASSWORD='password or token'
```

```python

import os

JENKINS_ENDPOINT = os.environ['JENKINS_ENDPOINT']
JENKINS_USER = os.environ['JENKINS_USER']
JENKINS_PASSWORD = os.environ['JENKINS_PASSWORD']

from api4jenkins import Jenkins
j = Jenkins(JENKINS_ENDPOINT, auth=(JENKINS_USER, JENKINS_PASSWORD))

```

### Add or create a new node


```python

j.nodes.create(**kwargs)
```

**`kwargs` must be :**

```json

{
 "name": "computeAgent123",
 "nodeDescription": "Compute Agent with docker container",
 "numExecutors": 1,
 "remoteFS": "/home/jenkins",
 "labelString": "computeAgent123",
 "mode": "NORMAL",
 "launcher":
    {
      "stapler-class": "hudson.slaves.JNLPLauncher",
      "webSocket": "true"
    },
"retentionStrategy": {"stapler-class": "hudson.slaves.RetentionStrategy$Always"},
"nodeProperties": {"stapler-class-bag": "true"}
}
```

*Where*

- `name` – name of node to create, `str`
- `nodeDescription` – Description of node, `str`
- `numExecutors` – number of executors for node, `int`
- `remoteFS` – Remote filesystem location to use, `str`
- `labelString` – Label to associate with node, `str`
- `mode` - choices `NORMAL` (use this node as much as possible) or `EXCLUSIVE` (Only build job with label matching ), `str`
- `launcher` – The launch method for the slave, `dict`,
   - *Example 01* - Launch agent by connecting to controller
```
"launcher":
    {
      "stapler-class": "hudson.slaves.JNLPLauncher",
      "webSocket": "true"
    }
```

  - *Example 02* - Launch agent via execution of command on the controller
```
"launcher":
    {
      "stapler-class": "hudson.slaves.CommandLauncher",
      "command": "run-agent",
      "webSocket": "true"
    }
```

  - *Example 03* - Launch agent via SSH
```
"launcher":
    {
      "stapler-class": "hudson.plugins.sshslaves.SSHLauncher",
      "host": "192.168.10.10",
      "port": 22,
      "credentialsId": "se-ssh-jenkins",
      "sshHostKeyVerificationStrategy":
          {"stapler-class": "hudson.plugins.sshslaves.verifiers.NonVerifyingKeyVerificationStrategy"},
      "webSocket": "true"
    }
```

- `retentionStrategy` -  Controls when Jenkins starts and stops this agent., `dict`
- `nodeProperties`- {"stapler-class-bag": "true"}, `dict`



### Get commandline agruments to run Jenkins agent docker image

```python

import requests
import json
url = 'http://127.0.0.1:8080/computer/computeAgent123/jenkins-agent.jnlp'
username = 'xXxXxXxX'
password = 'xXxXxXxXxXxXxXxX'
r = requests.get(url, auth = (username, password)

import xmltodict

data = xmltodict.parse(r.text)
secret = data['jnlp']['application-desc']['argument']
```

You will get below ENV vars from agrument

```
JENKINS_URL='http://127.0.0.1:8080'
JENKINS_SECRET='aaaaaaaaaabbbbbbbbbbbbbbcccccccccccccdddddddddddddddeeeeeeeeeeeefffff'
JENKINS_WEB_SOCKET=true
JENKINS_AGENT_NAME='computeAgent123'
```

> Now client need to run Jenkins docker agent with above ENV vars as mention above.


