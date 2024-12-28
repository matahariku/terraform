provider "aws" {
  region = var.region
}

# 1. VPC
resource "aws_vpc" "nangka" {
  cidr_block           = var.vpc_cidr
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
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "cafe-public"
  }
}

# 4. Private Subnet
resource "aws_subnet" "cafe_private" {
  vpc_id            = aws_vpc.nangka.id
  cidr_block        = var.private_subnet_cidr
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

  # Allow MongoDB access within VPC
  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # Allow SSH access to MongoDB
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Akses global (ganti dengan IP Anda jika perlu)
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

# 8. Instances
resource "aws_instance" "grafana" {
  ami           = var.grafana_ami
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.cafe_public.id
  security_groups = [aws_security_group.sg_grafana.id]

  tags = {
    Name = "grafana-instance"
  }
}

resource "aws_instance" "mongodb" {
  ami           = var.mongodb_ami
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.cafe_public.id
  associate_public_ip_address = true
  security_groups = [aws_security_group.sg_mongodb.id]

  tags = {
    Name = "mongoDB-instance"
  }
}
