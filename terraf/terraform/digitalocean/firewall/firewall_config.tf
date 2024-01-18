variable "accesskey" {
  type        = string
  description = "DigitalOcean access key"
}

variable "secretkey" {
  type        = string
  description = "DigitalOcean secret key"
}

variable "dropletid" {
  type        = string
  description = "ID of the DigitalOcean Droplet"
}

variable "organization" {
  type        = string
  description = "Name of the organization"
}

variable "workspace" {
  type        = string
  description = "Name of the workspace"
}

variable "dotoken" {
  type        = string
  description = "api token for digital ocean"
}

variable "hostname" {
  type        = string
  description = "Name of the droplet"
}

module "digitalocean_firewall" {
  source = "./digitalocean_firewall"

  accesskey = var.accesskey
  secretkey = var.secretkey
  dropletid = var.dropletid
  organization = var.organization
  workspace = var.workspace
  dotoken = var.dotoken
  hostname = var.hostname
}

