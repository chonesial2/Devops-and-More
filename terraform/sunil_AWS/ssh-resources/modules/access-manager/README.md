# Access Manager - Create terraform module for managing SSH users on machines

This module provision a user on SSH host with authentication using SSH key.



# Use module in `main.tf` file

module "access_manager" {
  source = "./modules/access-manager"

  ssh_host   = "hostname"
  ssh_user   = "ssh_user"
  username   = "remote_user_to_be_created"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCSfwkTibgCGTzMMJbq9zBXSDBlIVZMevMO7VHojqm8IhJ6CmzYuaq+fGVUfH8dCpz   remote_user@xyz.local "

}

