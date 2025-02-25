# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}

# Create a VPC
resource "aws_vpc" "anirban-iac-lab-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  instance_tenancy     = "default"
  tags = {
    Name = "${var.prefix}-vpc"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.anirban-iac-lab-vpc.id
  cidr_block        = var.subnet1_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "${var.prefix}-public_subnet1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.anirban-iac-lab-vpc.id
  cidr_block        = var.subnet2_cidr
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "${var.prefix}-public_subnet2"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.anirban-iac-lab-vpc.id
  cidr_block        = var.subnet3_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "${var.prefix}-private_subnet1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.anirban-iac-lab-vpc.id
  cidr_block        = var.subnet4_cidr
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "${var.prefix}-private_subnet2"
  }
}

resource "aws_subnet" "secure_subnet_1" {
  vpc_id            = aws_vpc.anirban-iac-lab-vpc.id
  cidr_block        = var.subnet5_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "${var.prefix}-secure_subnet1"
  }
}

resource "aws_subnet" "secure_subnet_2" {
  vpc_id            = aws_vpc.anirban-iac-lab-vpc.id
  cidr_block        = var.subnet6_cidr
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "${var.prefix}-secure_subnet2"
  }
}

resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.anirban-iac-lab-vpc.id

  tags = {
    Name = "${var.prefix}-internet_gateway"
  }
}

resource "aws_eip" "elastic_ip" {
  domain = "vpc"
  tags = {
    name = "${var.prefix}-elastic_ip"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_subnet_2.id

  tags = {
    Name = "${var.prefix}-NAT_gw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.internet_gw, aws_eip.elastic_ip, aws_vpc.anirban-iac-lab-vpc]
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.anirban-iac-lab-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gw.id
  }

  tags = {
    Name = "${var.prefix}-public_rt"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.anirban-iac-lab-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "${var.prefix}-private_rt"
  }
}

resource "aws_route_table_association" "public_rt_assoc1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_rt_assoc2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_rt_assoc1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_rt_assoc2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}