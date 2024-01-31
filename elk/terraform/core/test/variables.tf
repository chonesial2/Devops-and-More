
variable "environment" {
  type = string
  description = "Application Environment"
  default = "test"
}

variable "application_name" {
  type = string
  description = "Application Name"
  default = "demo-project"
}

variable "maintainer" {
  type = string
  description = "Maintainer"
  default = "StackExpress https://stackexpress.com"
}

variable "app_domain" {
  type = string
  description = "Application Domain"
  default = "example.com"
}

variable "aws_region" {
  type = string
  description = "Availabilty Zone 01"
  default = "ap-south-1"
}

variable "default_aws_availability_zone" {
  type = string
  description = "Availabilty Zone 01"
  default = "ap-south-1a"
}

variable "aws_availability_zone_01" {
  type = string
  description = "Availabilty Zone 01"
  default = "ap-south-1a"
}

variable "aws_availability_zone_02" {
  type = string
  description = "Availabilty Zone 02"
  default = "ap-south-1b"
}

variable "aws_availability_zone_03" {
  type = string
  description = "Availabilty Zone 03"
  default = "ap-south-1c"
}

variable "aws_vpc_cidr" {
  type = string
  description = "AWS VPC CIDR"
  default = "10.22.0.0/16"
}

variable "aws_subnet_private_01" {
  type = string
  description = "AWS VPC CIDR"
  default = "10.22.1.0/24"
}

variable "aws_subnet_private_02" {
  type = string
  description = "AWS VPC CIDR"
  default = "10.22.2.0/24"
}

variable "aws_subnet_private_03" {
  type = string
  description = "AWS VPC CIDR"
  default = "10.22.3.0/24"
}

variable "aws_subnet_public_01" {
  type = string
  description = "AWS VPC CIDR"
  default = "10.22.11.0/24"
}

variable "aws_subnet_public_02" {
  type = string
  description = "AWS VPC CIDR"
  default = "10.22.12.0/24"
}

variable "aws_subnet_public_03" {
  type = string
  description = "AWS VPC CIDR"
  default = "10.22.13.0/24"
}

variable "stackexpress_office_ips" {
  type = list(string)
  description = "StackExpress Office IPs"
  default = [ 
              "122.160.58.108/32",
              "180.151.12.226/32",
              "146.190.8.60/32"
            ]
}

