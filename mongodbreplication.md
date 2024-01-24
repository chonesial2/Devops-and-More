# MongoDb Replication 

## Prequisites 

1. More than one instance , you want to add into the replication cluster of Mongodb
2. Instances/Containers inside same subnet 
3. mongo:5.0 installed 

## Steps 


Open the configuration file on all the Instances and change the following 


```

vi etc/mongod.conf

```

change the binded ip to the localhost server's private ip 

on the same configuration file , move to the row for Replication configuration 

```
   replication:
      replSetName: "testreplicaserver"

```
Restart the server 

```

service mongod Restart

```

### Repeat these steps for all the instances 

##### Now enter the mongoDb command line tool using local server's private Ip

### Suppose your private ip is 192.168.1.4

```
mongo 192.168.1.4

```

#### Enter the replication command on the Primary instance of Replication set. 

```

rs.initiate ()

```
The command line tool will prompt Primary


## Add the slave nodes using their private ips 
### Suppose private ip is 192.168.1.10

```
rs.add("192.168.1.10")

```

#### Now On the Secondary server supposedly 192.168.1.10, the command line tool will be prompted as secondary 

# Repeat the rs.add("privateip") command on all the slave nodes. 

## You can Test by creating a new databse with a collection on Primary 

The newly created Databse will be replicated inside slave nodes also 
