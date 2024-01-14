
//Declaration of functionality 

terraform {
  required_version = "1.4.5"  # specify the Terraform version you're using
}

//Provider for aws instance for ecs module 

provider "aws" {
  access_key = "AKIATSPA4C3TTIRTSC5J"
  secret_key = "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"
  region     = var.aws_region
  #if you are running from AWS ec2 linux instance please use bellow credentials section
  #shared_credentials_file = "$HOME/.aws/credentials"
  #profile = "default"
}

