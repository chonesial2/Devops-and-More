**Create certficates**
```bash
docker-compose -f create-certs.yml run --rm create_certs
```
this command will creates certs directory which contains certificates

**up elastic search**
```bash
docker-compose -f docker-compose.tls.yml --profile es up -d
```
Generate the passwords by running below command 

```bash
docker exec es01 /bin/bash -c "bin/elasticsearch-setup-passwords auto --batch --url http://es01:9200"
```

after getting passwords add those in .env.kibana and up the kibana container by running below command

```bash
docker-compose -f kibana-docker-compose.yml up -d
```

**up apm service**

configure apm env and run the below command to up APM service

```bash
docker-compose -f apm-docker-compose.yml up -d
```