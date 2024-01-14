# Configure the AWS Provider

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# # Configure the AWS Provider
# provider "aws" {
#   region = var.aws_region
# }

provider "aws" {
  region = "ap-south-1"
}

data "aws_caller_identity" "current" {}
