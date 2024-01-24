# Setup Mongodb Master-Slave Replication
## Step 1: Install Mongodb on Master and Slave Nodes
##### Reference link for Install MongoDB Community Edition on Ubuntu
https://www.mongodb.com/docs/v5.0/tutorial/install-mongodb-on-ubuntu/
#### Step 1.1 
```sh
#Import the public key used by the package management system
$ sudo apt-get install gnupg
$ curl -fsSL https://pgp.mongodb.com/server-4.4.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-4.4.gpg \
   --dearmor
   
#Create a list file for MongoDB (ubuntu 20.04 (focal))   
$ echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-4.4.gpg ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list

#Reload local package database
$ sudo apt-get update

#Install the MongoDB packages (Install a specific release of MongoDB)
$ sudo apt-get install -y mongodb-org=4.4.20 mongodb-org-server=4.4.20 mongodb-org-shell=4.4.20 mongodb-org-mongos=4.4.20 mongodb-org-tools=4.4.20
```
## Step 2: Configure master server
#check the mongodb status
```sh
$ sudo service mongod status (Inactivity is fine, but do configuration changes.)
```
Open the mongodb configuration file.
```sh
$ sudo vim /etc/mongod.conf
```
Note: give the `master private ip` in bind-address
```sh
bindIp: 159.223.171.65 (#change 127.0.0.1 ip with your master private ip)
#replace rs1 with your replication name
replication:
    replSetName: "rs1" 
```
save & exit.
2.1: Restart the mongodb server for the configurations changes to take place.
```sh
$ sudo service mongod restart
```
```sh
$ sudo systemctl enable mongod (#optional)
```
2.2: Check the mongodb status to make sure all the configurations are applied as expected without any errors.
```sh
$ sudo service mongod status
```
2.3: Login to mongodb master server.
```sh
$ mongo --host 159.223.171.65
```
## Step 3: Configure slave server
#check the mongod status
```sh
$ sudo service mongod status (Inactivity is fine, but do configuration changes.)
```
Open the mongodb configuration file.
```sh
$ sudo vim /etc/mongod.conf
```
Note: give the `slave private ip` in bind-address
```sh
bindIp: 159.223.129.67 (#change 127.0.0.1 ip with your slave private ip)
#replace rs1 with your replication name
replication:
    replSetName: "rs1" 
```
save & exit.
3.1: Restart the mongodb server for the configurations changes to take place.
```sh
$ sudo service mongod restart
```
```sh
$ sudo systemctl enable mongod (#optional)
```
3.2: Check the mongodb status to make sure all the configurations are applied as expected without any errors.
```sh
$ sudo service mongod status
```
## Step 4: Initiate the master node and add the slave nodes' private IPs inside the master node. 
4.1: Login to master mongodb server.
```sh
$ mongo --host 159.223.171.65
```
#Initiate the master node
```sh
> rs.initiate()
#The command line tool will prompt Primary
rs1:PRIMARY>
```
#Add the slave nodes using their private ips
#check 27017 port is open in slave server
```sh
rs.add("159.223.129.67“)  —————   #1st slave private ip. (Enter “ “ in terminal manually otherwise error will come)
```
```sh
rs.add("172.31.34.249”)  —————   #2st slave private ip(optional)
```

## Step 5: Verify the mongodb Master-Slave Replication 
#### 5.1 : creating database and collections in master node
Login to master mongodb server
```sh
$ mongo --host 159.223.171.65
```
```sh
rs1:PRIMARY> rs.status()
   Result:
   Master node:primary
   1st slave  :secondary
   2nd slave  :secondary
```  
```sh
rs1:PRIMARY> show dbs
rs1:PRIMARY> use test    ——  #switched to db test
rs1:PRIMARY> db     — #to check whether in naga entered or not
rs1:PRIMARY> db.testcollection.insert({"name" : "saliva"})
rs1:PRIMARY> show collections
```
#### 5.2 : checking data replication in slave nodes
Login to slave mongodb server
```sh
$ mongo --host 159.223.129.67
```
```sh
rs.secondaryOk()  ———— #do this in slave nodes
rs1:SECONDARY> show dbs
rs1:SECONDARY> use test
rs1:SECONDARY> db 
rs1:SECONDARY> show collections
rs1:SECONDARY> db.testcollection.find()
```
## Step 6 : can't create databases and tables on a slave server
```sh
$ mongo --host 159.223.129.67
```
```sh
rs1:SECONDARY> use newtest
rs1:SECONDARY> db.testcollection.insert({"name" : "newtest"})
output:
WriteCommandError({
	"errmsg" : "not master",
	"codeName" : "NotWritablePrimary",
})
```

## Step 7 : check failover scenarios and availability
```sh
$ sudo service mongod stop   ———   #in master node
```
Check mongo in slave nodes
   Result:
   1st slave converts to primary
   2nd slave converts to secondary


