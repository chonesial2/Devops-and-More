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
  description = "define all the ssh keys"
}

variable "vpc_uuid" {
  type        = string
  description = "subnet where we need to create the droplet"
}
