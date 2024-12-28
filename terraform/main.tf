provider "aws" {
  region = "us-east-1"
}

# 1. VPC
resource "aws_vpc" "nangka" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "nangka"
  }
}

# 2. Internet Gateway
resource "aws_internet_gateway" "gw_nangka" {
  vpc_id = aws_vpc.nangka.id
  tags = {
    Name = "GW-nangka"
  }
}

# 3. Public Subnet
resource "aws_subnet" "cafe_public" {
  vpc_id                  = aws_vpc.nangka.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "cafe-public"
  }
}

# 4. Private Subnet
resource "aws_subnet" "cafe_private" {
  vpc_id            = aws_vpc.nangka.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "cafe-privat"
  }
}

# 5. Route Table
resource "aws_route_table" "route_private" {
  vpc_id = aws_vpc.nangka.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw_nangka.id
  }

  tags = {
    Name = "route-privat"
  }
}

# 6. Associate Route Table with Public Subnet
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.cafe_public.id
  route_table_id = aws_route_table.route_private.id
}

# 7. Security Groups

# Security Group for Grafana
resource "aws_security_group" "sg_grafana" {
  vpc_id = aws_vpc.nangka.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG-grafana"
  }
}

# Security Group for MongoDB
resource "aws_security_group" "sg_mongodb" {
  vpc_id = aws_vpc.nangka.id

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Hanya akses internal dalam VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG-mongodb"
  }
}
