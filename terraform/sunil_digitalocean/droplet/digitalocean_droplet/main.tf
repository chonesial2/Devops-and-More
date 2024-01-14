terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.34.1"
    }
  }
}

# Set the variable value in *.tfvars file
# or using -var="do_token=..." CLI option

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.dotoken
}

# Create a new Web Droplet in the region
resource "digitalocean_droplet" "web" {
  image        = var.dropletimage
  name         = var.dropletname
  region       = var.region 
  size         = var.size
  ssh_keys     = var.sshkeys
  vpc_uuid     = var.vpc_uuid
}




