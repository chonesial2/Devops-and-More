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

data "digitalocean_droplet" "my_droplet" {
  name = var.hostname
}
resource "digitalocean_firewall" "web" {
  name = "only-22-80-and-443"

  droplet_ids = [var.dropletid]



  inbound_rule {
    protocol         = "tcp"
    port_range       = "30555"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

}