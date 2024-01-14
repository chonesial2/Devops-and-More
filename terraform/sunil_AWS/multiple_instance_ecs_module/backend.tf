//back end for ecs module 
terraform {
  cloud {
    organization = "autoprods"

    workspaces {
      name = "demo-core-test"
    }
  }
}