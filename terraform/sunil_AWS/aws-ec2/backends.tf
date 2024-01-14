terraform {
  cloud {
    organization = "autoprods"

    workspaces {
      name = "demo-core-test"
    }
  }
}
