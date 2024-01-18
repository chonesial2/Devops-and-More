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
  description = "Name of the token"
}

variable "hostname" {
  type        = string
  description = "Name of the droplet"
}
// Now you can use these variables in your module as needed.

