terraform {
  required_version = "1.4.5"  # specify the Terraform version you're using
}

provider "aws" {
  region  = "ap-south-1"
  access_key = "AKIATSPA4C3TTIRTSC5J"
  secret_key = "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"
}

variable "region" {
  type = string
  description = "region is south asia mumbai"
  default = "ap-south-1"
  }


variable "instance" {
  type = string
  description = "Instance type for EC2"
  default     = "t2.small"
}

variable "ami" {
  type        = string
  description = "AMI ID for EC2"
  default     = "ami-02eb7a4783e7e9317"
}
variable "access" {
  type        = string
  description = "access keys for aws"
  default     = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
}
variable "secret" {
  type        = string
  description = "access keys for aws"
  default     = "xxxxxxxxxxxxxxxxxxxxxxxxxxxx"
}

variable "instancename" {
  type = string
  description = "Name of ec2 instance"
  default     = "testinstanceserver"
}

variable "organization" {
  type        = string
  description = "name of the organization"
  value = "autoprods"
}


module "ec2_module" {
  source = "./ec2_module"

  region   = var.region
    access   = var.access
    secret   = var.secret
    ami      = var.ami
    instance = var.instance
    organization = var.organization


}
