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
