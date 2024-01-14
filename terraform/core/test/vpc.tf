// VPC
resource "aws_vpc" "main" {
  cidr_block               = var.aws_vpc_cidr
  instance_tenancy         = "default"

  enable_dns_hostnames     = true

  tags = {
    Name           = join("-", [ var.application_name, var.environment, "vpc" ])
    environment    = var.environment
    maintainer     = var.maintainer
  }
}

// Internet Gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  depends_on = [ aws_vpc.main ]

  tags = {
    Name           = join("-", [ var.application_name, var.environment, "igw" ])
    environment    = var.environment
    maintainer     = var.maintainer
  }
}



//Private Subnets

resource "aws_subnet" "private-01" {
  vpc_id                         = aws_vpc.main.id
  cidr_block                     = var.aws_subnet_private_01
  availability_zone              = var.aws_availability_zone_01

  map_public_ip_on_launch        = false

  depends_on                     = [ aws_vpc.main ]

  tags = {
    Name           = join("-", [ var.application_name, var.environment, "private", "subnet", "01" ])
    environment    = var.environment
    maintainer     = var.maintainer
  }
}

resource "aws_subnet" "private-02" {
  vpc_id                         = aws_vpc.main.id
  cidr_block                     = var.aws_subnet_private_02
  availability_zone              = var.aws_availability_zone_02

  map_public_ip_on_launch        = false

  depends_on                     = [ aws_vpc.main ]

  tags = {
    Name           = join("-", [ var.application_name, var.environment, "private", "subnet", "02" ])
    environment    = var.environment
    maintainer     = var.maintainer
  }
}

resource "aws_subnet" "private-03" {
  vpc_id                         = aws_vpc.main.id
  cidr_block                     = var.aws_subnet_private_03
  availability_zone              = var.aws_availability_zone_03

  map_public_ip_on_launch        = false

  depends_on                     = [ aws_vpc.main ]

  tags = {
    Name           = join("-", [ var.application_name, var.environment, "private", "subnet", "03" ])
    environment    = var.environment
    maintainer     = var.maintainer
  }
}


// Public Subnets

resource "aws_subnet" "public-01" {
  vpc_id                         = aws_vpc.main.id
  cidr_block                     = var.aws_subnet_public_01
  availability_zone              = var.aws_availability_zone_01

  map_public_ip_on_launch        = true

  depends_on                     = [ aws_vpc.main ]


  tags = {
    Name           = join("-", [ var.application_name, var.environment, "public", "subnet", "01" ])
    environment    = var.environment
    maintainer     = var.maintainer
  }
}

resource "aws_subnet" "public-02" {
  vpc_id                         = aws_vpc.main.id
  cidr_block                     = var.aws_subnet_public_02
  availability_zone              = var.aws_availability_zone_02

  map_public_ip_on_launch        = true

  depends_on                     = [ aws_vpc.main ]

  tags = {
    Name           = join("-", [ var.application_name, var.environment, "public", "subnet", "02" ])
    environment    = var.environment
    maintainer     = var.maintainer
  }
}

resource "aws_subnet" "public-03" {
  vpc_id                         = aws_vpc.main.id
  cidr_block                     = var.aws_subnet_public_03
  availability_zone              = var.aws_availability_zone_03

  map_public_ip_on_launch        = true

  depends_on                     = [ aws_vpc.main ]

  tags = {
    Name           = join("-", [ var.application_name, var.environment, "public", "subnet", "03" ])
    environment    = var.environment
    maintainer     = var.maintainer
  }
}


// Elastic IPs

resource "aws_eip" "nat" {
  vpc                       = true

  tags = {
    Name           = join("-", [ var.application_name, var.environment, "eip", "nat" ])
    environment    = var.environment
    maintainer     = var.maintainer
  }

}


// NAT Gateway

resource "aws_nat_gateway" "ngw" {
  allocation_id           = aws_eip.nat.id
  subnet_id               = aws_subnet.public-01.id

  depends_on              = [ aws_eip.nat, aws_internet_gateway.igw ]

  tags = {
    Name           = join("-", [ var.application_name, var.environment, "nat" ])
    environment    = var.environment
    maintainer     = var.maintainer
  }

}

// Route Tables

resource "aws_route_table" "rt-private" {
  vpc_id                  = aws_vpc.main.id

  route {
    cidr_block             = "0.0.0.0/0"
    nat_gateway_id         = aws_nat_gateway.ngw.id
  }

  // route {
  //   ipv6_cidr_block    = "::/0"
  //   gateway_id         = aws_nat_gateway.ngw.id
  // }

  depends_on              = [ aws_vpc.main, aws_nat_gateway.ngw ]

  tags = {
    Name           = join("-", [ var.application_name, var.environment, "rt", "private" ])
    environment    = var.environment
    maintainer     = var.maintainer
  }

}

resource "aws_route_table" "rt-public" {
  vpc_id                  = aws_vpc.main.id

  route {
    cidr_block         = "0.0.0.0/0"
    gateway_id         = aws_internet_gateway.igw.id
  }

  route {
    ipv6_cidr_block    = "::/0"
    gateway_id         = aws_internet_gateway.igw.id
  }


  depends_on              = [ aws_vpc.main, aws_internet_gateway.igw ]

  tags = {
    Name           = join("-", [ var.application_name, var.environment, "rt", "public" ])
    environment    = var.environment
    maintainer     = var.maintainer
  }

}


// Route Table Associations

resource "aws_route_table_association" "subnet-private-01" {
  subnet_id      = aws_subnet.private-01.id
  route_table_id = aws_route_table.rt-private.id
}

resource "aws_route_table_association" "subnet-private-02" {
  subnet_id      = aws_subnet.private-02.id
  route_table_id = aws_route_table.rt-private.id
}

resource "aws_route_table_association" "subnet-private-03" {
  subnet_id      = aws_subnet.private-03.id
  route_table_id = aws_route_table.rt-private.id
}

resource "aws_route_table_association" "subnet-public-01" {
  subnet_id      = aws_subnet.public-01.id
  route_table_id = aws_route_table.rt-public.id
}

resource "aws_route_table_association" "subnet-public-02" {
  subnet_id      = aws_subnet.public-02.id
  route_table_id = aws_route_table.rt-public.id
}

resource "aws_route_table_association" "subnet-public-03" {
  subnet_id      = aws_subnet.public-03.id
  route_table_id = aws_route_table.rt-public.id
}


