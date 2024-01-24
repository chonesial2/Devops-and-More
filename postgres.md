# PostgreSQL Replication Setup

Following are the steps to set up replication in PostgreSQL, allowing you to create a replica (slave) server that synchronizes data with a master server.

## Prerequisites

- PostgreSQL installed on the master and replica servers.
- Editing tool
- Access to the PostgreSQL configuration files.



## Steps to Set Up Replication

- [Installing postgress on ubuntu 22.04 ](#Installation))
- [Understanding basics](#basics)
- [Master server configuration](#repmaster)
- [Slave node configuration](#repslave)
- [Testing the Replication](#reptest)


### Installation of Postgress on Master as well as Slave 
<div id="installation"></div>

Installing PostgreSQL

```apt-get install update```

```
apt-get Install postgresql postgresql-contrib
```



### Basic commands
<div id="basics"></div>

switching to postgres user 

```

Sudo su postgres

```

opening the PostgreSQL command line tool 

```

pSql

```


Creating new user 

```

CREATE USER user_1 WITH PASSWORD ‘user@password’

```

Giving all the privileges to new user 

```

ALTER USER user_1 WITH SUPERUSER;

```

Listing all users 

```

SELECT usename FROM pg_user;

```


# Replication <div id="repmaster"></div>


## Steps for configuration of master server

1. #### change listening address to all 
go to the main configuration file 

```
sudo vi /etc/postgresql/14/main/posgresql.conf 

```

change listen configuration to 

```
listen_addresses = '*'          # what IP address(es) to listen on;
```

2. #### Change login configuration to let all using password 
go to pg_hba.conf

```
sudo vi /etc/postgresql/14/main/pg_hba.conf 
```

change the values 

```
TYPE   DATABASE        USER            ADDRESS                 METHOD

host    all            all            0.0.0.0/0                 md5
```

Restart Postgres

```
systemctl restart postgresql
```


3. #### Create replication role with password

switch to postgress user 
```

sudo su postgres

```

open postgres command line tool 

```

pSql 

```
write this command for creating ROLE name = "replication" and password = "password"

```

CREATE ROLE replication WITH REPLICATION PASSWORD 'password' LOGIN;

```

exit command line tool

exit postgres user 


4. #### Setting WAL (write ahead logs) mechanism 
 
open postgresql.conf


```

sudo vi /etc/postgresql/14/main/posgresql.conf 

```

change the Following

```

wal_level setting to hot_standby 
max_wal_Senders = 5 
wal_keep_size =  as per requirement 

```

5. #### Setting up the Archive characteristics (As per the load)
on postgress.conf 
```

archive_mode - on
Archive commands = ‘cp %p /var/lib/postgres/14/archive/%f’ 

```

Create archive folder 

```

Mkdir /var/lib/postgres/14/archive

```

Change ownership 

```

Chown postgres.postgres /var/lib/postgres/14/archive

```


6. #### Add Replica Slave ip Address

Open pg_hba.conf

```

sudo vi /etc/postgresql/14/main/pg_hba.conf 

```

edit the following 

```

TYPE         DATABASE        USER            ADDRESS                   METHOD

Host 		replication		replication	 	slave.public.ip.add/32		md5 
```


                         Restart the Postgresql 

```     
                                                
                        systemctl restart postgresql
                                                        
```

## Configuration for Adding Slave <div id="repslave"></div>

### Above Step 1 to 5 are all same 

6. #### Add Replica Master Ip address in configuration 

Open pg_hba.conf

```
sudo vi /etc/postgresql/14/main/pg_hba.conf 
```
edit the following 

```

TYPE         DATABASE        USER            ADDRESS                   METHOD

Host 		replication		replication	 	master .public.ip.add/32		md5 

```

                                                        Restart the Postgresql 
                                                        ```
                                                        systemctl restart postgresql
                                                        ```

7. #### Run Basebackup command to forward backup for replication 

switch to postgres user 

```

sudo su postgres

```

Afte that run the following command

```

pg_basebackup -h 13.234.176.126 -D /var/lib/postgresql/14/main -P -U replication

```

Enter the password created while creating the replication role

exit postgress user 

8. #### Turn hot Standby on 
open configuration file 

```

vi /etc/postgresql/14/main/postgresql.conf 

```

search and change the following

```

Turn hot_standby = “on”

```

9. #### Create Recovery configuration 
Recovery file is used for replication and recovery of data 

create a new file 

```

 vi var.lib/postgresql/14/main/recovery.conf 

```
add the following command 

```

standby_mode = 'on'
primary_conninfo = 'host=primary_server_ip port=5432 user=replication_password=replication_password'
restore_command = 'cp /var/lib/postgresql/archive/%f %p'
trigger_file = '/var/lib/postgresql/14/main/trigger_file'

```                                                      

10. #### Restart the Slave node 


```

systemctl restart postgresql

```

11. #### Testing the Replication <div id="reptest"></div>


on your master server 

switch to postgres user 

```

sudo su postgress

```

now open the psql command line tool and create a database 

```

psql

```


Create database with name replica_test

```

create database replica_test;

```

##### Output will be 
```

CREATE DATABASE 

```

#### Now go to your Slave node , switch to Postgress user and open = psql command line tool 

```

\l

```

# the output will show Default Databases along the Newly replicated from Master 



```

  Name      |  Owner   | Encoding | Collate |  Ctype  |   Access privileges
---------------+----------+----------+---------+---------+-----------------------
 replica_set   | postgres | UTF8     | C.UTF-8 | C.UTF-8 |
 postgres      | postgres | UTF8     | C.UTF-8 | C.UTF-8 |
 template0     | postgres | UTF8     | C.UTF-8 | C.UTF-8 | =c/postgres          +
               |          |          |         |         | postgres=CTc/postgres
 template1     | postgres | UTF8     | C.UTF-8 | C.UTF-8 | =c/postgres          +
               |          |          |         |         | postgres=CTc/postgres
(4 rows)

```
