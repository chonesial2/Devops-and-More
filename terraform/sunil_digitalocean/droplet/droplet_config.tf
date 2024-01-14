variable "vpcname" {
  type        = string
  description = "VPC of the DigitalOcean Droplet"
}

variable "subnetname" {
  type        = string
  description = "Subnet for Droplet"
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

variable "dropletname" {
  type        = string
  description = "Name of the droplet"
}

variable "dropletimage" {
  type        = string
  description = "image of the droplet"
}

variable "region" {
  type        = string
  description = "region of the droplet"
}

variable "size" {
  type        = string
  description = "size of the droplet"
}

variable "sshkeys" {
  type        = set(string)
  description = "sshb keys"
}


variable "vpc_uuid" {
  type        = string
  description = "vpc where we need to create the droplet"
}



module "digitalocean_droplet" {
  source = "./digitalocean_droplet"
  
  vpcname          = var.vpcname
  subnetname       = var.subnetname
  organization     = var.organization
  workspace        = var.workspace
  dotoken          = var.dotoken
  dropletname      = var.dropletname
  dropletimage     = var.dropletimage
  region           = var.region
  size             = var.size
  sshkeys          = var.sshkeys
  vpc_uuid         = var.vpc_uuid
}

