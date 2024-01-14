resource "ssh_resource" "add" {

  when = "create"

  host  = var.ssh_host
  user  = var.ssh_user
  agent = true

  timeout = "10m"

  commands = [
    "sudo useradd -m -s /bin/bash ${var.username}",
    "sudo mkdir /home/${var.username}/.ssh",
    "sudo touch /home/${var.username}/.ssh/authorized_keys",
    "sudo chmod 700 /home/${var.username}/.ssh",
    "sudo chown -R ${var.username}:${var.username} /home/${var.username}/.ssh/",
    "echo '${var.public_key}' | sudo tee /home/${var.username}/.ssh/authorized_keys",
    "echo 'Created User - ${var.username}' && exit 0;"
  ]
}

resource "ssh_resource" "remove" {

  when = "destroy"

  host  = var.ssh_host
  user  = var.ssh_user
  agent = true

  timeout = "10m"

  commands = [
    "sudo userdel ${var.username}",
    "sudo rm -rf /home/${var.username}",
    "echo 'Deleted User - ${var.username}' && exit 0;"
  ]

}
