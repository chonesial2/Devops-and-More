// Public Web
resource "aws_security_group" "allow-public-web" {
  name              = join("-", [ "allow", "public", "web" ])
  description       = "Allow Public Web"
  vpc_id            = aws_vpc.main.id

  ingress {
    description         = "Allow web from Everywhere"
    from_port           = 80
    to_port             = 80
    protocol            = "tcp"
    cidr_blocks         = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks    = [ "::/0" ]
  }

  ingress {
    description         = "Allow web from Everywhere"
    from_port           = 443
    to_port             = 443
    protocol            = "tcp"
    cidr_blocks         = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks    = [ "::/0" ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name           = join("-", [ "allow", "public", "web" ])
    environment    = var.environment
    maintainer     = var.maintainer
  }
}

// Limit Web
resource "aws_security_group" "limit-web" {
  name              = join("-", [ "limit", "web" ])
  description       = "Limit Web Access"
  vpc_id            = aws_vpc.main.id

  ingress {
    description   = "Allow web access to StackExpress"
    from_port     = 80
    to_port       = 80
    protocol      = "tcp"
    cidr_blocks   = var.stackexpress_office_ips
  }

  ingress {
    description   = "Allow web access to StackExpress"
    from_port     = 443
    to_port       = 443
    protocol      = "tcp"
    cidr_blocks   = var.stackexpress_office_ips
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name           = join("-", [ "limit", "web" ])
    environment    = var.environment
    maintainer     = var.maintainer
  }
}

// Limit SSH
resource "aws_security_group" "limit-ssh" {
  name              = join("-", [ "limit", "ssh" ])
  description       = "Limit SSH Access"
  vpc_id            = aws_vpc.main.id

  ingress {
    description   = "Limit SSH access"
    from_port     = 22
    to_port       = 22
    protocol      = "tcp"
    cidr_blocks   = var.stackexpress_office_ips
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name           = join("-", [ "limit", "ssh" ])
    environment    = var.environment
    maintainer     = var.maintainer
  }
}


// Testing Mode
resource "aws_security_group" "testing-mode" {
  name              = join("-", [ "testing", "mode", "dangerous" ])
  description       = "Testing Mode Dangerous"
  vpc_id            = aws_vpc.main.id

  ingress {
    description         = "Allow Everything from Everywhere (Dangerous)"
    from_port           = 0
    to_port             = 65535
    protocol            = "tcp"
    cidr_blocks         = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks    = [ "::/0" ]
  }

  ingress {
    description         = "Allow Everything from Everywhere (Dangerous)"
    from_port           = 0
    to_port             = 65535
    protocol            = "udp"
    cidr_blocks         = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks    = [ "::/0" ]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name           = join("-", [ "testing", "mode", "dangerous" ])
    environment    = var.environment
    maintainer     = var.maintainer
  }
}
