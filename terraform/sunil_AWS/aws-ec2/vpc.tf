//create vpc
resource "aws_vpc" "mainvpc" {
  cidr_block = "179.110.0.0/16"
}


//Create Subnets
resource "aws_subnet" "Public" {
  vpc_id     = aws_vpc.mainvpc.id
  cidr_block = "179.110.1.0/24"

  tags = {
    Name = "Public"
  }
}

resource "aws_subnet" "Pvt" {
  vpc_id     = aws_vpc.mainvpc.id
  cidr_block = "179.110.111.0/24"

  tags = {
    Name = "Pvt"
  }
}

//internet gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.mainvpc.id

  tags = {
    Name = "internet gateway"
  }
}

//private nat

resource "aws_nat_gateway" "nat" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.Public.id
}

//ROUTE TABLE

resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.mainvpc.id

  route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.gw.id
  }
}

//ROTEPRIVATE
resource "aws_route_table" "PrivateRT" {
  vpc_id = aws_vpc.mainvpc.id
  route {
      cidr_block = "0.0.0.0/0" 
    gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "PrivateRT"
  }
}

//ROUTE TABLE ASSOCIATion

resource "aws_route_table_association" "publicass" {
  subnet_id      = aws_subnet.Public.id
  route_table_id = aws_route_table.PublicRT.id
}

resource "aws_route_table_association" "pvtass" {
  subnet_id      = aws_subnet.Pvt.id
  route_table_id = aws_route_table.PrivateRT.id
}

