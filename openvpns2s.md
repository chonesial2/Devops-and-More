# Site to Site VPN connection 


## Content 

#### Prerequisite 
#### Networking 
#### Installing OpenVPN
#### Configuration
#### Testing
#### Multiple Endpoints through VPN Server  


## Prerequisite 

1. Central Server and Client Server 
2. Ubuntu 20.04
3. Internet and appropriate Networking 
4. Access to configurations
5. OpenVPN

## Networking 

First of all Set up Servers that needs to be connected using VPN tunnel .

Central Server will be set up on the Office Premises and 

Client server will be set up on Client's Side 

for the technical execution , 
we require following assets 

- private ip 
- subnet 
- subnet mask 
- public ip 


## Installing VPN

##### follow below for installing OpenVPN

update Ubuntu library 

```
apt update
apt upgrade

```
Install neccessary utilities 

```
apt install wget net-tools gnupg

```

add keys 

```
wget -qO - https://as-repository.openvpn.net/as-repo-public.gpg | apt-key add -

```

add new Entry 

```
echo "deb http://as-repository.openvpn.net/as/debian focal main">/etc/apt/sources.list.d/openvpn-as-repo.list

```

update the repo 

```
apt update
```

install the services 

```
apt-get install openvpn 

```

##### Now that we have installed OpenVPN , We can Explore more on Added Features for VPN Network Such as "ca.cert" 
from here https://www.digitalocean.com/community/tutorials/how-to-set-up-an-openvpn-server-on-ubuntu-18-04#step-12-revoking-client-certificates


## Configuration File 

now the Templates for each type of config file is present at " /usr/share/doc/openvpn/examples/sample-config-files "

we need to transfer "static-office.conf" file to openvpn configuration directory 


```

cp /usr/share/doc/openvpn/examples/sample-config-files/static-office.conf /etc/openvpn/s2s.conf

```

Repeat this steps for both the servers 


### Editing the Configuration files 

on the Office server add remote ip as client's server 
on the Client server add remote ip as office's server

along with above, do the following changes

((((( ***** i have highlighted the changes using ---------------->>>>>> this arrow ******* ))))) 

```

#
# Sample OpenVPN configuration file for
# home using a pre-shared static key.
#
# '#' or ';' may be used to delimit comments.

# Use a dynamic tun device.
# For Linux 2.2 or non-Linux OSes,
# you may want to use an explicit
# unit number such as "tun1".
# OpenVPN also supports virtual
# ethernet "tap" devices.
dev tun

# Our OpenVPN peer is the office gateway.
# ---------------->>>>>> add remote (client side public ip)
remote xxxxxxxxxxx. 

# 10.1.0.2 is our local VPN endpoint (home).
# 10.1.0.1 is our remote VPN endpoint (office).
ifconfig 10.1.0.2 10.1.0.1 

# Our up script will establish routes
# once the VPN is alive.
#up ./home.up ---------------->>>>>> comment this

# Our pre-shared static key
#secret static.key ---------------->>>>>> comment this 

# Cipher to use
cipher AES-256-CBC

# OpenVPN 2.0 uses UDP port 1194 by default
# (official port assignment by iana.org 11/04).
# OpenVPN 1.x uses UDP port 5000 by default.
# Each OpenVPN tunnel must use
# a different port number.
# lport or rport can be used
# to denote different ports
# for local and remote.
#---------------->>>>>> uncomment port and set the value to 1195
port 1195

# Downgrade UID and GID to
# "nobody" after initialization
# for extra security.
# ---------------->>>>>> uncomment user and group  
 user nobody
 group nogroup

# If you built OpenVPN with
# LZO compression, uncomment
# out the following line.
; comp-lzo

# Send a UDP ping to remote once
# every 15 seconds to keep
# stateful firewall connection
# alive.  Uncomment this
# out if you are using a stateful
# firewall.
; ping 15


auth-user-pass /etc/openvpn/s2s-auth.txt

# Uncomment this section for a more reliable detection when a system
# loses its connection.  For example, dial-ups or laptops that
# travel to other locations.
#---------------->>>>>> uncomment ping setting and persist setting
 ping 15
 ping-restart 45
 ping-timer-rem
 persist-tun
 persist-key

# Verbosity level.
# 0 -- quiet except for fatal errors.
# 1 -- mostly quiet, but display non-fatal network errors.
# 3 -- medium output, good for normal operation.
# 9 -- verbose, good for troubleshooting
verb 3
#---------------->>>>>> add log file here
log /etc/openvpn/s2s.log
#---------------->>>>>> insert routing config here for both the server with their subnet and subnet mask
route 10.108.16.0 255.255.240.0
route 10.122.0.0 255.255.240.0

```

##### Save the file 

### now to apply changes do the following 


##### stop openvpn@s2s

```

systemctl stop openvpn@s2s

```

##### stop openvpn 

```

systemctl stop openvpn 

```
##### start openvpn 

```
systemctl start openvpn 

```

##### start openvpn@s2s 


```

systemcctl start openvpn@s2s

```

#### tail the log file 

```

tail -f /etc/openvpn/s2s.log 

```

now you should see the output relate to the configuration 

### test the connectivity 

now after changing the configuration on both the sides you can test the connectivity using any method via private ips communication.

-----------------------------------------------------------------------------------------------------------------------------------------

# Section 2 :


## Multiple Endpoints through VPN Server 

#### For Allowing Multiple Servers , Machines or Subnets to be inside a VPN server , we will use following steps : 

1 - Configure your Machine 

2- ## Create Configuration file ;  client.ovpn and server.conf 


Now , Just run this script on Main VPN server 


```
curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
chmod +x openvpn-install.sh

```


now run the script


```
./openvpn-install.sh

```

follow the options 

choose port 
choose tcp 
name the client 


3- Set up the server ; server.conf

there will be two files added named clientname.ovpn 

and server.conf(/etc/openvpn/server.conf)

We will transfer the clientname.ovpn to the remote client servers for later use 


and open server.conf for setting up server 


```
 vi /etc/openvpn/server.conf

```


and add these commands , do not add comments 


          ```
            duplicate-cn // add duplicate - cn for enabling multiple client hosting

            server <subnetip> <subnetmask> //change the server subnet ip and subnet mask 
             
            client-to-client // add this syntax for enabling client to client communication

            push "route <pvtsubnetofclient> <pvtsubnetmask>"
            push "route <pvtsubnetofclient> <pvtsubnetmask>" //add private subnet route for enabling private subnetting through VPN
          ```      

Run these command starting VPN server 

 ```
     systemctl stop openvpn
```

start openvpn 


```

  systemctl start openvpn 

```
     
start openvpn using preffered server configuration saved in server.conf 


```

systemctl start openvpn@server

```
ADD YOUR HOST MACHINE TO THE VPN-SERVER AS PRIOR



4- ## Set up Remote Clients  (Repeat this step on all the client)

important - ADD YOUR HOST MACHINE TO THE VPN-SERVER AS PRIOR

After transfering the clientname.ovpn to the remote client servers 

Go to the Remote servers and perform 

     
       apt-get update && apt-get upgrade 

install the openVPN 

```    
apt-get install openvpn 
```    
       
After the installation 

5. locate and open client.ovpn and perform following 


```
vi /root/client.ovpn
```

-Add private subnet and subnet mask for push the subnet at the end of the fie 

```
push "<private-subnet> <private-subnet-mask>"
```


### Search for syntaxes containing dns options and delete them if you want to run the vpn in detached mode 

save the client.ovpn into /tmp directory


```
cp /root/client.ovpn /tmp/clinet.ovpn 
```

now start openvpn 

```
systemctl start openvpn 

```

now mount the client.ovpn file for connecting to openvpn server 

```

openvpn --config /tmp/client.ovpn

```

if you want to run in detached mode / background mode 

```

openvpn --config /tmp/client.ovpn --daemon


```




IN FEW SECONDS, THE CLIENT WILL BE ADDED TO THE SERVER, 


PERFORM STEP NUMBER FOUR AND FIVE FOR CONNECTING ALL THE CLIENTS 
          
          
