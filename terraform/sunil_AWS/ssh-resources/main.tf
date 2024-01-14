# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Use module in `main.tf` file
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

module "access_manager" {
  source = "./modules/access-manager"

  ssh_host   = "host01.example.com"
  ssh_user   = "demo"
  username   = "test_user_01"
  public_key = "ssh-rsa AAAA....................................TYFYHJFJGJKHK test_user_01@local "

}

