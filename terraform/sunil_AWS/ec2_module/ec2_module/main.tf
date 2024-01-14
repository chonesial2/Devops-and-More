resource "aws_security_group" "sgi" {
  name        = "sgi"
  description = "Allow TLS inbound traffic"

  ingress {
    description         = "Allow web from Everywhere"
    from_port           = 80
    to_port             = 80
    protocol            = "tcp"
    cidr_blocks         = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks    = [ "::/0" ]
  }


 egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
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
  content  = tls_private_key.rsa.private_key_pem
  filename = "terastate"

depends_on = [
    aws_security_group.sgi,  # Depend on aws_security_group resource
  ]


}

resource "aws_instance" "instancename" {
  ami           = var.ami
  instance_type = var.instance
vpc_security_group_ids = [aws_security_group.sgi.id]
 key_name = aws_key_pair.terastate.key_name   # Reference the key name of the aws_key_pair resource

depends_on = [
    aws_key_pair.terastate,  # Depend on aws_key_pair resource
  ]


}
