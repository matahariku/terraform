provider "aws" {
  region = "us-east-1"
}

# 1. VPC
resource "aws_vpc" "nangka_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "nangka-vpc"
  }
}

# 2. Internet Gateway
resource "aws_internet_gateway" "nangka_igw" {
  vpc_id = aws_vpc.nangka_vpc.id
  tags = {
    Name = "GW-nangka"
  }
}

# 3. Subnet Publik
resource "aws_subnet" "cafe_public" {
  vpc_id                  = aws_vpc.nangka_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "cafe-public"
  }
}

# 4. Subnet Privat
resource "aws_subnet" "cafe_private" {
  vpc_id                  = aws_vpc.nangka_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1a"
  tags = {
    Name = "cafe-privat"
  }
}

# 5. Route Table untuk Subnet Privat
resource "aws_route_table" "route_private" {
  vpc_id = aws_vpc.nangka_vpc.id
  tags = {
    Name = "route-privat"
  }
}

resource "aws_route_table_association" "private_association" {
  subnet_id      = aws_subnet.cafe_private.id
  route_table_id = aws_route_table.route_private.id
}

# 6. Route Table untuk Subnet Publik
resource "aws_route_table" "route_public" {
  vpc_id = aws_vpc.nangka_vpc.id
  tags = {
    Name = "route-public"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.route_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.nangka_igw.id
}

resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.cafe_public.id
  route_table_id = aws_route_table.route_public.id
}

# 7. Security Group untuk Grafana
resource "aws_security_group" "sg_grafana" {
  name        = "SG-grafana"
  vpc_id      = aws_vpc.nangka_vpc.id
  description = "Allow Grafana traffic"

  ingress {
    from_port   = 3000
    to_port     = 3000
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

# 8. Security Group untuk MongoDB
resource "aws_security_group" "sg_mongodb" {
  name        = "SG-mongodb"
  vpc_id      = aws_vpc.nangka_vpc.id
  description = "Allow MongoDB traffic"

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["10.0.2.0/24"]
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
