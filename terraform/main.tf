provider "aws" {
  region = var.region
}

resource "aws_instance" "grafana" {
  ami           = var.grafana_ami
  instance_type = var.instance_type
  key_name      = var.key_name

  tags = {
    Name = "Grafana"
  }
}

resource "aws_instance" "mongodb" {
  ami           = var.mongodb_ami
  instance_type = var.instance_type
  key_name      = var.key_name

  tags = {
    Name = "MongoDB"
  }
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "Main VPC"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr

  tags = {
    Name = "Private Subnet"
  }
}
