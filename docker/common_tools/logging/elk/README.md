
[TOC]

# Logging


- **Ref**

- https://www.elastic.co/guide/en/elastic-stack-get-started/current/get-started-docker.html
- https://umasrinivask.medium.com/dockerize-elasticsearch-kibana-with-x-packs-security-237589acb3fd
- https://codingfundas.com/setting-up-elasticsearch-6-8-with-kibana-and-x-pack-security-enabled/index.html
- https://www.elastic.co/blog/elasticsearch-security-configure-tls-ssl-pki-authentication



```bash
docker run \
docker.elastic.co/beats/heartbeat:7.16.2 \
setup -E setup.kibana.host=kibana.example.com:5601 \
-E output.elasticsearch.hosts=["es.example.com:9200"]

```

------------------

## Pre-requisites

To run a container using ELK docker images, you will need the following:

- **Docker**

  Install [Docker](https://docs.docker.com/engine/install/), either using a native package (Linux) or wrapped in a virtual machine
  - [Install Docker Desktop on Mac](https://docs.docker.com/desktop/mac/install/)
  - [Install Docker Desktop on Windows](https://docs.docker.com/desktop/windows/install/)
- **Docker Compose** - [Install docker-compose](https://docs.docker.com/compose/install/)
- **A minimum of 4GB RAM assigned to Docker**
  Elasticsearch alone needs at least 2GB of RAM to run.
  In Docker Desktop, you configure resource usage on the Advanced tab in Preference (macOS) or Settings (Windows).
- A limit on mmap counts equal to 262,144 or more

  <span style="color:red">**!! WARNING !!** This is the most frequent reason for Elasticsearch failing to start since Elasticsearch version 5 was released.</span>

  **On Linux**, use `sysctl vm.max_map_count` on the host to view the current value, and see [Set vm.max_map_count to at_least 262144](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html#_set_vm_max_map_count_to_at_least_262144)
  > Note that the limits **must be changed on the host;** they cannot be changed from within a container.



## Setup

Now we will run ELK services using docker-compose in both Non-TLS and TLS mode.

### Run in Docker with TLS disabled (Non-TLS mode)

We have assigned the profiles to services in docker-compose file, we can start specific services or all services using profiles.

**Bring up only elastic Search**

- Create `.env.es` file (take reference from `./configs/.env.es.example`)
- Ensure ENV vars in file - `.env.es` like below

```bash

# Basic configs
cluster.initial_master_nodes=es01,es02
cluster.name=es-docker-cluster
bootstrap.memory_lock=true
ES_JAVA_OPTS=-Xms512m -Xmx512m

```

- Run the Elasticsearch service

```bash

docker-compose --profile es -f docker-compose.nontls.yml up
```

- Open `http://127.0.0.1:9200/` in the browser.


```json

{
  "name": "es01",
  "cluster_name": "es-docker-cluster",
  "cluster_uuid": "02Kyd--NShaLV7DK8Wo5-A",
  "version": {
    "number": "7.16.2",
    "build_flavor": "default",
    "build_type": "docker",
    "build_hash": "2b937c44140b6559905130a8650c64dbd0879cfb",
    "build_date": "2021-12-18T19:42:46.604893745Z",
    "build_snapshot": false,
    "lucene_version": "8.10.1",
    "minimum_wire_compatibility_version": "6.8.0",
    "minimum_index_compatibility_version": "6.0.0-beta1"
  },
  "tagline": "You Know, for Search"
}
```

**Bring up Elasticsearch with Kibana**

- After creating `.env.es` file mentioned in above steps, Include `kibana` profile also

```bash

docker-compose --profile es --profile kibana -f docker-compose.nontls.yml up
```

- Wait for the services to come up and Open `http://127.0.0.1:5601/` in the browser.`


**Bring up all services in compose file**

- Create `.env.es` file file mentioned in above steps.
- Create `./configs/apm-server.yml` file (take reference from `./configs/apm-server.yml.example`)

```yaml

apm-server:
  host: "0.0.0.0:8200"
  rum:
    enabled: true

  # To enable remote configuration
  kibana:
    enabled: true
    host: "http://kibana:5601"

# https://www.elastic.co/guide/en/apm/server/current/configuring-output.html
output:
  elasticsearch:
    hosts:
      - es01:9200
      - es02:9200

queue.mem.events: 4096

max_procs: 4
```

- Run below command

```bash

docker-compose --profile logging -f docker-compose.nontls.yml up
```


> When we're done experimenting, we can tear down the containers and volumes by running `docker-compose -f docker-compose.nontls.yml down -v`.


### Run in Docker with TLS enabled

If security features are enabled, we must configure Transport Layer Security (TLS) encryption for the Elasticsearch transport layer.

**Generate certificates for Elasticsearch**

- Generate certificates for Elasticsearch by bringing up the `create-certs` container.

```bash

docker-compose -f create-certs.yml run --rm create_certs
```

> It will generate the certificates in ./certs dir

```bash

ls ./certs

elastic-certificates.p12  elastic-stack-ca.p12
```

**Bring up the Elasticsearch**

- Set ENV vars in `.env.es` file (take reference from `./configs/.env.es.example`)
- Enable security and set passowrd for Elasticsearch

```bash

# Basic configs
cluster.initial_master_nodes=es01,es02
cluster.name=es-docker-cluster
bootstrap.memory_lock=true
ES_JAVA_OPTS=-Xms512m -Xmx512m

# Security Configs
xpack.security.enabled=true
xpack.security.transport.ssl.enabled=true
xpack.security.transport.ssl.keystore.type=PKCS12
xpack.security.transport.ssl.verification_mode=certificate
xpack.security.transport.ssl.keystore.path=elastic-certificates.p12
xpack.security.transport.ssl.truststore.path=elastic-certificates.p12
xpack.security.transport.ssl.truststore.type=PKCS12

xpack.security.audit.enabled=true

```

- Run the Elasticsearch cluster in docker

```bash

docker-compose -f docker-compose.tls.yml --profile es up -d
```

<span style="color:red">**!! WARNING !!** At this point, Kibana cannot connect to the Elasticsearch cluster. We must generate a password for the built-in `kibana_system` user. </span>

- Run `elasticsearch-setup-passwords` tool to generate passwords for all built-in users, including the `kibana_system` user.

``` bash

docker exec es01 /bin/bash -c "bin/elasticsearch-setup-passwords auto --batch --url http://es01:9200"
```

<span style="color:red">**!! WARNING !!** Make a note of the generated passwords. We must configure the `kibana_system` user password in the `.env.kibana` file to enable Kibana to connect to Elasticsearch, and we'all need the password for the `elastic` superuser to log in to Kibana and submit requests to Elasticsearch. </span>


- Set ENV vars in `.env.kibana` (take reference from `./configs/.env.kibana.example`)

```bash

ELASTICSEARCH_HOSTS=http://es01:9200
SERVER_NAME=kibana.example.com

ELASTICSEARCH_USERNAME=kibana_system
ELASTICSEARCH_PASSWORD=CHANGE_ME

# server.publicBaseUrl
SERVER_PUBLICBASEURL=https://kibana.example.com/

# xpack.encryptedSavedObjects.encryptionKey
#  - A string of 32 or more characters used to encrypt sensitive properties on alerting rules
#  - and actions before they’re stored in Elasticsearch.
XPACK_ENCRYPTEDSAVEDOBJECTS_ENCRYPTIONKEY="fhf1234567890123456789012345678901234567890123456789012345678901234567890"

```

- Use `docker-compose` to start the Kibana:

```bash

docker-compose -f docker-compose.tls.yml --profile es --profile kibana up -d
```

- Open Kibana to load sample data and interact with the cluster: https://127.0.0.1:5601


## HeartBeat with roles

**Ref:** https://www.elastic.co/guide/en/beats/heartbeat/current/feature-roles.html

- We may need to assign a higher permission role to user first.
- Then it is supposed to work with heartbeat_writer role


## APM with roles

**Ref:**
- https://www.elastic.co/guide/en/apm/server/current/privileges-to-publish-events.html


## Filebeat with roles

**Ref:**

- https://www.elastic.co/guide/en/beats/filebeat/7.16/privileges-to-setup-beats.html
- https://www.elastic.co/guide/en/beats/filebeat/current/configuration-filebeat-options.html

- **Enable filebeat**

- The user need these additional inbuilt roles for setup. These might be removed after inital setup is done.
  - kibana_admin
  - ingest_admin
  - machine_learning_admin


```bash
sudo filebeat modules enable squid
```

```bash
sudo vim /etc/filebeat/modules.d/squid.yml
```

- Enable SystemLogs

```bash
sudo filebeat modules enable system
```

```bash
sudo vim /etc/filebeat/modules.d/system.yml
```

- Enable iptables

```bash
sudo filebeat modules enable iptables
```

```bash
sudo vim /etc/filebeat/modules.d/iptables.yml
```

## Auditbeat with roles

**Ref:**
- https://www.elastic.co/guide/en/beats/auditbeat/current/privileges-to-setup-beats.html
- https://www.elastic.co/guide/en/beats/auditbeat/current/privileges-to-publish-events.html


------------------

## Issues


#### <span style="color:red">Transport SSL must be enabled if security is enabled on a [basic] license.</span>

Solution: Need to enable SSL by setting this var

`xpack.security.transport.ssl.enabled=true`



#### <span style="color:red">send message failed javax.net.ssl.SSLHandshakeException: Received fatal alert: handshake_failure</span>

SSL cert is not created


/usr/share/elasticsearch/config/elastic-certificates.p12



#### <span style="color:red">Failure to install package [docker] | invalid_index_template_exception | index_template [metrics-docker.event] invalid, cause [index template [met... </span>


#### <span style="color:red">bootstrap check failure [1] of [1]: max virtual memory areas vm.max_map_count [65530] is too low... </span>

**Ref:**
- https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html#_set_vm_max_map_count_to_at_least_262144

**To Run Elastic serach in one host and kibana and apm in another host modify the .env files like below**

**example files:**

- Set ENV vars in `.env.es` file

```bash

# Basic configs
#cluster.initial_master_nodes=es01
#cluster.name=es-docker-cluster
bootstrap.memory_lock=true
ES_JAVA_OPTS=-Xms2g -Xmx2g
discovery.type=single-node

# Security Configs
xpack.security.enabled=true
xpack.security.transport.ssl.enabled=true
xpack.security.transport.ssl.keystore.type=PKCS12
xpack.security.transport.ssl.verification_mode=certificate
xpack.security.transport.ssl.keystore.path=elastic-certificates.p12
xpack.security.transport.ssl.truststore.path=elastic-certificates.p12
xpack.security.transport.ssl.truststore.type=PKCS12

xpack.security.audit.enabled=true

````

- `.env.kibana`

```bash
ELASTICSEARCH_HOSTS=http://1.2.3.43:9200/ #ip of the elastic search node
#SERVER_NAME=kibana.example.com

ELASTICSEARCH_USERNAME=kibana_system
ELASTICSEARCH_PASSWORD=XXXXXXXXXXX

# server.publicBaseUrl
SERVER_PUBLICBASEURL=http://1.2.3.44:5601/  #ip of the kibana node

# xpack.encryptedSavedObjects.encryptionKey
XPACK_ENCRYPTEDSAVEDOBJECTS_ENCRYPTIONKEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
````

- `apm-server.yml`

```bash
apm-server:
  host: "0.0.0.0:8200"
  auth:
    secret_token: "xxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  rum:
    enabled: true
  # To enable remote configuration
  kibana:
    enabled: true
    host: "http://1.2.3.44:5601/"  #ip of kibana

# https://www.elastic.co/guide/en/apm/server/current/configuring-output.html
output:
  elasticsearch:
    hosts:
      - http://1.2.3.43:9200  #Ip of elastic search
    username: "elastic"
    password: "xxxxxxxxxxx"

queue.mem.events: 4096

max_procs: 4

```

- `.env.apm`

````bash
output.elasticsearch.hosts=http://1.2.3.43:9200  #ip of elastic search host
SERVER_PUBLICBASEURL=http://1.2.3.44:5601 #ip of kibana host
````




