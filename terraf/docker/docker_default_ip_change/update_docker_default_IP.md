
# Update Docker Default IP Configuration
updating Docker's default IP (172.17.0.1/16) with a different IP range. In this case, we are using IP addresses from the `10.x.x.x` IP series. Follow the steps below:

Display the current network configuration:
```bash
ifconfig
 ```

Forcefully leave the Docker Swarm (if applicable):
```bash
docker swarm leave --force
Note: The application using Swarm will get delete.
```

List Docker nodes (if applicable):
```bash
docker node ls
```

List Docker networks:
```bash
docker network ls
```

Prune unused Docker networks:
```bash
docker network prune
```

 Prune Docker system, removing unused data:
```bash
docker system prune
```

Display the network configuration again:
```bash
ifconfig
```

Stop the Docker socket:
```bash
sudo systemctl stop docker.socket
```

Check the status of the Docker socket:
```bash
sudo systemctl status docker.socket
```

Set the Docker gateway bridge down:
```bash
sudo ip link set dev docker_gwbridge down
```

Delete the Docker gateway bridge:
```bash
sudo ip link delete docker_gwbridge
```

Set the Docker0 bridge down:
```bash
sudo ip link set dev docker0 down
```

Delete the Docker0 bridge:
```bash
sudo ip link delete docker0
```

Display the network configuration again to verify whether docker0 and docker_gwbridge are down or not:
```bash
ifconfig
```

Edit the `daemon.json` file using the Vim editor:
```bash
vim /etc/docker/daemon.json
```
Add the following content to `daemon.json`:
```json
{
  "default-address-pools": [
    {
      "base": "10.16.0.1/16",
      "size": 24
    }
  ],
  "bip": "10.17.0.1/24",
  "fixed-cidr": "10.17.0.0/24"
}
```

Start the Docker service:
```bash
sudo systemctl start docker
```

Check the status of the Docker service:
```bash
sudo systemctl status docker
```

Display the network configuration again:
```bash
ifconfig
```

Initialize Docker Swarm with the specified advertise address:
```bash
docker swarm init --advertise-addr 100.64.10.6

Note: Replace the IP address 100.64.10.6 with the desired server private IP.
```

List Docker nodes:
```bash
docker node ls
```

Deploy any `testing application using a Docker stack or Docker Compose file`, whether the network is updated with the new `10.x.x.x` series IP or not, by entering the `ifconfig` command.
```bash
sudo APP_IMAGE=image_name docker compose up -d
or
sudo APP_IMAGE=image_name docker stack deploy stack_name --compose-file docker-compose-stack.yml --with-registry-auth

Note: Replace the image_name with the actual application image name.
```
List Docker networks to verify whether the `application` network has been created or not.:
```bash
docker network ls
```

Display the network configuration again to verify whether the `application` network changed to `10.x.x.x` series IP or not:
```bash
ifconfig
```

View Docker logs for the last hour to check for any network errors logs if the applications have not come up.
```bash
sudo journalctl -u docker --since "1 hour ago" | less
```

View Docker logs for the last 5 minutes:
```bash
sudo journalctl -u docker --since "5 minutes ago" | less
```