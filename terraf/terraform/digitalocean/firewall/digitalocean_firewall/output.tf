# output.tf

output "firewall_rules" {
  value = digitalocean_firewall.web.inbound_rule
}

output "droplet_hostname" {
  value = data.digitalocean_droplet.my_droplet.name
}

output "droplet_id" {
  value = data.digitalocean_droplet.my_droplet.id
}

output "droplet_ip" {
  value = data.digitalocean_droplet.my_droplet.ipv4_address
}
