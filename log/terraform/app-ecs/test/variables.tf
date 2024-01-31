
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

// Should be moved to another place
variable "db_password" {
  type = string
  description = "DB Password"
  default = "XXXXXXX"
}

variable "aws_account_id" {
  type = string
  description = "AWS Account ID"
  default = "950087689901"
}


// https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/enable-access-logs.html
// account ID for LB
variable "alb_ac_id" {
  type = string
  description = "Load Balancer Account ID"
  default = "718504428378"
}

variable "app_domain" {
  type = string
  description = "Application Domain"
  default = "example.com"
}

# ## adding secret values and it has been picked from terrafotm tfvars
# variable "db-username" {}
# variable "db-password" {}
# variable "db-host" {}
# variable "db-port" {}
# variable "db-app-key" {}
# variable "db-database" {}
# variable "db-connection" {
#   description = "connection name"
# }
