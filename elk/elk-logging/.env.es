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
ELASTIC_PASSWORD=xxxxxxxxxx
