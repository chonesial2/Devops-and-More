# nfs-server

A lightweight, robust, flexible, and containerized NFS server.

## Requirements

- The Docker host kernel will need the following kernel modules
  - `nfs`
  - `nfsd`
  - `rpcsec_gss_krb5` (only if Kerberos is used)

- Enable above modules on the Docker host with:

```sh
sudo modprobe {nfs,nfsd,rpcsec_gss_krb5}
```

- The container will need to run with `--privileged`. This is necessary as the server needs to mount several filesystems inside the container to support its operation.

- The container will need local access to the files you'd like to serve via NFS.

## Usage

Starting the server

```sh
docker-compose up -d
```
