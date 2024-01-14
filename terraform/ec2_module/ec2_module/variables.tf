variable "region" {
  type        = string
  description = "availability zone mumbai"
}


variable "access" {
  type        = string
  description = "access key for iam"
}

variable "secret" {
  type        = string
  description = "secret key for IAM"
}

variable "instancename" {
  type = string
  description = "Name of ec2 instance"
}

variable "ami" {
  type        = string
  description = "image"
}

variable "instance" {
  type        = string
  description = "compatible instance will ami"
}

variable "organization" {
  type        = string
  description = "name of the organization"
}
