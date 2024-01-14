terraform {
  required_version = "1.4.5"  # specify the Terraform version you're using
}

provider "aws" {
  region  = "ap-south-1"
  access_key = "AKIATSPA4C3TTIRTSC5J"
  secret_key = "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"
}

variable "family" {
  type        = string
  description = "aws_ecs_task_definition "
  default     = "Newtaskdef"
}

variable "contname" {
  type        = string
  description = "name of container taskfamily"
  default     = "httpdcont"
}

variable "imagename" {
  type        = string
  description = "image to be used for container "
  default     = "httpd"
}



variable "organization" {
  type        = string
  description = "name of the organization"
   default = "autoprods"
}


module "ecsmodule" {
  source = "./ecsmodule"

    organization = var.organization
    family = var.family
    contname = var.contname
    imagename = var.imagename 
  
}
