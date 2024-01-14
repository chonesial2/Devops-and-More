[TOC]


# ERPNext

This setup use **Nginx** as a proxy server, which pass the connection requests to  ERPNext-nginx service.

Single instance of MariaDB will be installed and act as database service for all the benches/projects installed on the server.

Each instance of ERPNext project (bench) will have its own redis, socketio, gunicorn, nginx, workers and scheduler. It will connect to internal MariaDB by connecting to MariaDB network

## Pre-requisites

- **OS** - Ubuntu LTS 20.04
- **Docker**
- **Docker compose v2**
- **Nginx**


## Install MariaDB

**Set password in ENV file**

```sh
cd compose-mariadb
cp .env.example .env
```

```yaml
# File - .env

DB_PASSWORD=xXxXxXxXxXxXxX
```

**Deploy the mariadb container**

```sh
docker compose --project-name mariadb up -d
```

> This will make `mariadb` service available under `mariadb-network` network. Data will reside in `./data/mariadb`.


```
docker ps
CONTAINER ID   IMAGE                             COMMAND                  CREATED       STATUS                  PORTS                      NAMES
...
c951b4466f22   mariadb:10.6                      "docker-entrypoint.s…"   2 minutes ago   Up 2 minutes (healthy)   3306/tcp                   mariadb
...
```

## Install ERPNext

**Set password in ENV file**

```sh
cd compose-erpnext
cp .env.example .env
```

**Now, Edit `.env` file in your favourite editor and set ENV vars**

**Deploy erpnext containers**

```sh
docker compose --project-name erpnext up -d
```

```sh
docker ps

CONTAINER ID   IMAGE                             COMMAND                  CREATED       STATUS                  PORTS                      NAMES
...
a34c662e3e55   frappe/erpnext-nginx:v13.28.0     "/docker-entrypoint.…"   6 hours ago   Up 6 hours              127.0.0.1:8080->8080/tcp   upwire-erp-frontend-1
19872b38defc   frappe/frappe-socketio:v13.28.0   "docker-entrypoint.s…"   6 hours ago   Up 6 hours                                         upwire-erp-websocket-1
9b88d1c11d0e   frappe/erpnext-worker:v13.28.0    "bench worker --queu…"   6 hours ago   Up 6 hours                                         upwire-erp-queue-long-1
c52aca9054ce   frappe/erpnext-worker:v13.28.0    "bench worker --queu…"   6 hours ago   Up 6 hours                                         upwire-erp-queue-default-1
40fae6fee330   frappe/erpnext-worker:v13.28.0    "bench worker --queu…"   6 hours ago   Up 6 hours                                         upwire-erp-queue-short-1
1564f20d463d   frappe/erpnext-worker:v13.28.0    "/home/frappe/frappe…"   6 hours ago   Up 6 hours                                         upwire-erp-backend-1
27e47773c2b8   frappe/erpnext-worker:v13.28.0    "bench schedule"         6 hours ago   Up 6 hours                                         upwire-erp-scheduler-1
e88d43b85042   redis:6.2-alpine                  "docker-entrypoint.s…"   6 hours ago   Up 6 hours              6379/tcp                   upwire-erp-redis-1
...
```

> ERPnext frontend URL is `127.0.0.1:8080`. So, Setup Nginx reverse proxy for you ERPNext domain - `erp.example.com`

