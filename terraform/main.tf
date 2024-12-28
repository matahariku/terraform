provider "aws" {
  region = var.region
}

# Resource: VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "Main VPC"
  }
}

# Resource: Public Subnet
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr

  tags = {
    Name = "Public Subnet"
  }
}

# Resource: Private Subnet
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr

  tags = {
    Name = "Private Subnet"
  }
}

# Resource: Grafana Instance
resource "aws_instance" "grafana" {
  ami           = var.grafana_ami
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.public.id # Grafana berada di subnet publik

  tags = {
    Name = "Grafana"
  }
}

# Resource: MongoDB Instance
resource "aws_instance" "mongodb" {
  ami           = var.mongodb_ami
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.private.id # MongoDB berada di subnet privat

  tags = {
    Name = "MongoDB"
  }
}
