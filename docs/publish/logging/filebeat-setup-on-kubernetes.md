#  Setup Filebeat on Kubernetes cluster

You can use Filebeat [Docker images](https://www.docker.elastic.co/r/beats/filebeat) on Kubernetes to retrieve and ship container logs.

## Requirements

- Kubernetes >= 1.21
- Helm3
- kubectl

> NOTE: This doc is tested with Filebeat version `7.16`

## Working of Filebeat on K8s

You deploy Filebeat as a **DaemonSet** to ensure there’s a running instance on each node of the cluster.

The Docker logs host folder (`/var/lib/docker/containers`) is mounted on the Filebeat container.
Filebeat starts an input for the files and begins harvesting them as soon as they appear in the folder.


## Deployment

You can deploy the Filebeat either using k8s manifest file or using Helm chart.

## Deploy using k8s manifest file

To download the manifest file, run:

```sh
FILEBEAT_VERSION='7.16'
curl -L -O https://raw.githubusercontent.com/elastic/beats/$FILEBEAT_VERSION/deploy/kubernetes/filebeat-kubernetes.yaml
```

To deploy Filebeat to Kubernetes, run:

```sh
kubectl create -f filebeat-kubernetes.yaml
```

To check the status, run:

```sh
$ kubectl --namespace=kube-system get ds/filebeat

NAME       DESIRED   CURRENT   READY     UP-TO-DATE   AVAILABLE   NODE-SELECTOR   AGE
filebeat   3            3        0         3           0           <none>          1m
```

> Everything is deployed under the kube-system namespace by default. To change the namespace, modify the manifest file.


## Deploy using Helm chart

Add the Elastic Helm charts repo:

```sh
helm repo add elastic https://helm.elastic.co
```

Download the `values.yaml` file to iverride chart values

```sh
FILEBEAT_VERSION='7.16'
curl -L -O https://raw.githubusercontent.com/elastic/helm-charts/$FILEBEAT_VERSION/filebeat/values.yaml
```

Open the `values.yaml` file in your favourite editor and update the file with following configs:

```yaml

clusterRoleRules:
  - apiGroups:
      - extensions
      - apps
      - ""
    resources:
      - namespaces
      - pods
      - events
      - deployments
      - nodes
      - replicasets
    verbs:
      - get
      - list
      - watch

daemonset:
  # Annotations to apply to the daemonset
  annotations: {}
  # additionals labels
  labels: {}
  affinity: {}
  # Include the daemonset
  enabled: true
  # Extra environment variables for Filebeat container.
  envFrom: []
  # - configMapRef:
  #     name: config-secret
  extraEnvs:
  - name: 'ELASTICSEARCH_USERNAME'
    valueFrom:
      secretKeyRef:
        name: filebeat-secret
        key: ELASTICSEARCH_USERNAME
  - name: 'ELASTICSEARCH_PASSWORD'
    valueFrom:
      secretKeyRef:
        name: filebeat-secret
        key: ELASTICSEARCH_PASSWORD
  extraVolumes:
    []
    # - name: extras
    #   emptyDir: {}
  extraVolumeMounts:
    []
    # - name: extras
    #   mountPath: /usr/share/extras
    #   readOnly: true
  hostNetworking: false
  # Allows you to add any config files in /usr/share/filebeat
  # such as filebeat.yml for daemonset
  filebeatConfig:
    filebeat.yml: |
      filebeat.autodiscover:
         providers:
           - type: kubernetes
             node: ${NODE_NAME}
             hints.enabled: true
             hints.default_config:
               type: container
               paths:
                 - /var/log/containers/*${data.kubernetes.container.id}.log
      processors:
        - add_cloud_metadata:
        - add_host_metadata:
        - drop_event:
            when:
              or:
                - not:
                    regexp:
                      kubernetes.container.name: "^nginx.*"
        - decode_json_fields:
            fields: ["message"]
            target: "json"
            overwrite_keys: true

      output.elasticsearch:
        hosts:
          # Update Elasticsearch hostname with port
          - "elasticsearch.logging.svc.cluster.local"
        username: '${ELASTICSEARCH_USERNAME}'
        password: '${ELASTICSEARCH_PASSWORD}'
        # bulk_max_size: 2
        # timeout: 600
        indices:
        - index: "projectname-appname-%{[kubernetes.namespace]}-%{+yyyy.MM}"

      setup.ilm.enabled: false

  # Only used when updateStrategy is set to "RollingUpdate"
  maxUnavailable: 1
  nodeSelector: {}
  # A list of secrets and their paths to mount inside the pod
  # This is useful for mounting certificates for security other sensitive values
  secretMounts: []
  #  - name: filebeat-certificates
  #    secretName: filebeat-certificates
  #    path: /usr/share/filebeat/certs
  # Various pod security context settings. Bear in mind that many of these have an impact on Filebeat functioning properly.
  #
  # - User that the container will execute as. Typically necessary to run as root (0) in order to properly collect host container logs.
  # - Whether to execute the Filebeat containers as privileged containers. Typically not necessarily unless running within environments such as OpenShift.
  securityContext:
    runAsUser: 0
    privileged: false
  resources:
    requests:
      cpu: "100m"
      memory: "100Mi"
    limits:
      cpu: "1000m"
      memory: "200Mi"
  tolerations: []

deployment:
  # Include the deployment
  enabled: false

# Replicas being used for the filebeat deployment
replicas: 1

extraContainers: ""
# - name: dummy-init
#   image: busybox
#   command: ['echo', 'hey']

extraInitContainers: []
# - name: dummy-init

# Root directory where Filebeat will write data to in order to persist registry data across pod restarts (file position and other metadata).
hostPathRoot: /var/lib

dnsConfig: {}
# options:
#   - name: ndots
#     value: "2"
hostAliases: []
#- ip: "127.0.0.1"
#  hostnames:
#  - "foo.local"
#  - "bar.local"
image: "docker.elastic.co/beats/filebeat"
imageTag: "7.16.4-SNAPSHOT"
imagePullPolicy: "IfNotPresent"
imagePullSecrets: []

livenessProbe:
  exec:
    command:
      - sh
      - -c
      - |
        #!/usr/bin/env bash -e
        curl --fail 127.0.0.1:5066
  failureThreshold: 3
  initialDelaySeconds: 10
  periodSeconds: 10
  timeoutSeconds: 5

readinessProbe:
  exec:
    command:
      - sh
      - -c
      - |
        #!/usr/bin/env bash -e
        filebeat test output
  failureThreshold: 3
  initialDelaySeconds: 10
  periodSeconds: 10
  timeoutSeconds: 5

# Whether this chart should self-manage its service account, role, and associated role binding.
managedServiceAccount: true

podAnnotations:
  {}
  # iam.amazonaws.com/role: es-cluster

# Custom service account override that the pod will use
serviceAccount: ""

# Annotations to add to the ServiceAccount that is created if the serviceAccount value isn't set.
serviceAccountAnnotations:
  {}
  # eks.amazonaws.com/role-arn: arn:aws:iam::111111111111:role/k8s.clustername.namespace.serviceaccount

# How long to wait for Filebeat pods to stop gracefully
terminationGracePeriod: 30
# This is the PriorityClass settings as defined in
# https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#priorityclass
priorityClassName: ""

updateStrategy: RollingUpdate

# Override various naming aspects of this chart
# Only edit these if you know what you're doing
nameOverride: ""
fullnameOverride: ""

# DEPRECATED
affinity: {}
envFrom: []
extraEnvs: []
extraVolumes: []
extraVolumeMounts: []
# Allows you to add any config files in /usr/share/filebeat
# such as filebeat.yml for both daemonset and deployment
filebeatConfig: {}
nodeSelector: {}
podSecurityContext: {}
resources: {}
secretMounts: []
tolerations: []
labels: {}

```

Create `filebeat-secret` on k8s

```sh
kubectl create secret generic filebeat-secret --from-literal=ELASTICSEARCH_USERNAME=elastic --from-literal=ELASTICSEARCH_PASSWORD=StrongPassword
```

Install on k8s:

```sh
helm install filebeat --version 7.16 elastic/filebeat -f values.yaml
```

## References

- https://www.elastic.co/guide/en/beats/filebeat/7.16/running-on-kubernetes.html#running-on-kubernetes
- https://github.com/elastic/helm-charts/tree/7.16/filebeat


