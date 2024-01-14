ElastAlert 2 - Automated rule-based alerting for Elasticsearch
====

**ElastAlert 2** is a simple framework for alerting on anomalies, spikes, or other patterns of interest from data in **Elasticsearch** and **OpenSearch**.

# Overview

It works by combining Elasticsearch with two types of components, rule types and alerts. Elasticsearch is periodically queried and the data is passed to the rule type, which determines when a match is found. When a match occurs, it is given to one or more alerts, which take action based on the match.


# Running ElastAlert 2

ElastAlert 2 can easily be run as a **Docker container** or directly on your machine as a **Python package**.

## Run as a Docker container

Use prebuilt docker images from [Docker Hub](https://hub.docker.com/r/jertel/elastalert2) or [GitHub Container Registry](https://github.com/jertel/elastalert2/pkgs/container/elastalert2%2Felastalert2)

A properly configured `config.yaml` file must be mounted into the container during startup of the container. Use the [example file](https://github.com/jertel/elastalert2/blob/master/examples/config.yaml.example) as a template.

- Create a sample `config.yaml` inside `configs` directory like below

```
# File - configs/config.yaml

rules_folder: /opt/elastalert/rules

run_every:
  seconds: 10

buffer_time:
  minutes: 15

es_host: 127.0.0.1
es_port: 9200

# If basic authentication is enabled
es_username: elastic
es_password: CHANGE_ME


writeback_index: elastalert_status

alert_time_limit:
  days: 2

```

- Create a rule directory and rules file like `rules/rule1.yaml`

```
File - rules/rule1.yaml

# Unique name for alert
name: "rule1"
type: "frequency"

# Define index pattern to monitor
index: "myindex-*"
is_enabled: true
num_events: 2
realert:
  minutes: 1
terms_size: 50
timeframe:
  minutes: 1
timestamp_field: "@timestamp"
timestamp_type: "iso"
use_strftime_index: false
alert_subject: "Test {} 123 aa☃"
alert_subject_args:
  - "message"
  - "@log_name"
alert_text: "Test {}  123 bb☃"
alert_text_args:
  - "message"

# define alert query
filter:
  - query:
      query_string:
        query: "@timestamp:*"

# List of alerts
alert:
  - "slack"

slack_webhook_url: 'https://hooks.slack.com/services/AAAAAAAAAAAA/BBBBBBBBBBBB'
slack_emoji_override: ":kissing_cat:"
slack_msg_color: "warning"
slack_parse_override: "none"

```

- And then mount both into the ElastAlert 2 container

```
configs/config.yaml
rules/rule1.yaml

```

> You may explore the **example** folder for more options


- Run the ElastAlert 2 server using docker-compose

```
docker-compose up -d
```

- Or Run using docker command with required arguments given below

```
docker run -d --name elastalert --restart=unless-stopped \
-v $(pwd)/configs/config.yaml:/opt/elastalert/config.yaml \
-v $(pwd)/rules:/opt/elastalert/rules \
jertel/elastalert2:2.3.0 --verbose
```

- Check logs

```
docker logs -f elastalert

```

## Run as a Python package

- Install **ElastAlert 2** using pip

```
python3 -m pip install elastalert2
```

- First, we need to create an index for ElastAlert 2 to write to by running `elastalert-create-index` and following the instructions.

> **Note**: that this manual step is only needed by users that run ElastAlert 2 directly on the host, whereas container users will automatically see these indexes created on startup.

```
elastalert-create-index
```

> For information about what data will go here, see [ElastAlert 2 Metadata Index](https://elastalert2.readthedocs.io/en/latest/elastalert_status.html#metadata)

- Run Elastalert 2 on host

```
elastalert --verbose --rule rules/rule1.yaml --config configs/config.yaml

```

# Rule Types and Configuration Options

Examples of several types of rule configuration can be found in the [examples/rules](https://github.com/jertel/elastalert2/tree/master/examples/rules) folder.

<span style="color:magenta"> All “time” formats are of the form `unit: X` where unit is one of weeks, days, hours, minutes or seconds. Such as `minutes: 15` or `hours: 1`.</span>

## Common Configuration Options

Refer - https://elastalert2.readthedocs.io/en/latest/ruletypes.html#common-configuration-options

## Rule Types

Refer - https://elastalert2.readthedocs.io/en/latest/ruletypes.html#ruletypes

## Alerts

Refer - https://elastalert2.readthedocs.io/en/latest/ruletypes.html#alerts
