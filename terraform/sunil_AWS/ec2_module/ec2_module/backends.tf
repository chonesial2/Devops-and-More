terraform {
  cloud {
    organization = var.organization

    workspaces {
      name = "demo-core-test"
    }
  }
}
