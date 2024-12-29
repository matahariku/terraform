provider "aws" {
  region = var.region
}

# VPC
resource "aws_vpc" "nangka" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "nangka"
  }
}

# Public Subnet
resource "aws_subnet" "cafe_public" {
  vpc_id                  = aws_vpc.nangka.id
  cidr_block              = var.subnet_public_cidr
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "cafe-public"
  }
}

# Private Subnet
resource "aws_subnet" "cafe_private" {
  vpc_id            = aws_vpc.nangka.id
  cidr_block        = var.subnet_private_cidr
  availability_zone = "us-east-1a"
  tags = {
    Name = "cafe-private"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "gw_nangka" {
  vpc_id = aws_vpc.nangka.id
  tags = {
    Name = "GW-nangka"
  }
}

# Route Table
resource "aws_route_table" "public_routes" {
  vpc_id = aws_vpc.nangka.id

  route = [
    {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.gw_nangka.id
    }
  ]

  tags = {
    Name = "nangka-public-routes"
  }
}

# Route Table Association
resource "aws_route_table_association" "public_subnet" {
  subnet_id      = aws_subnet.cafe_public.id
  route_table_id = aws_route_table.public_routes.id
}

# Security Group for MongoDB
resource "aws_security_group" "sg_mongodb" {
  vpc_id = aws_vpc.nangka.id
  name   = "SG-mongodb"

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = [var.subnet_public_cidr]
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

# Security Group for Grafana
resource "aws_security_group" "sg_grafana" {
  vpc_id = aws_vpc.nangka.id
  name   = "SG-grafana"

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

# MongoDB Instance
resource "aws_instance" "mongodb" {
  ami           = "ami-01816d07b1128cd2d"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.cafe_private.id
  security_groups = [aws_security_group.sg_mongodb.name]
  key_name      = var.key_pair_name

  tags = {
    Name = "MongoDBInstance"
  }
}

# Grafana Instance
resource "aws_instance" "grafana" {
  ami           = "ami-0e2c8caa4b6378d8c"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.cafe_public.id
  security_groups = [aws_security_group.sg_grafana.name]
  key_name      = var.key_pair_name

  tags = {
    Name = "GrafanaInstance"
  }
}

