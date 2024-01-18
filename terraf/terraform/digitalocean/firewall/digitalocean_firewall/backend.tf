terraform {
  cloud {
    organization = var.organization

    workspace {
      name = var.workspace
    }
  }
}