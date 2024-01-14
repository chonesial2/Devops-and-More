resource "aws_instance" "server1" {
  ami           = var.ami
  instance_type = var.instance
}

resource "aws_key_pair" "terastate" {
  key_name   = "terastate"
  public_key = tls_private_key.rsa.public_key_openssh
}

# RSA key of size 4096 bits
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "terastate" {
  content  = "tls_private_key.rsa.private_key.pem"
  filename = "terastate"
}
