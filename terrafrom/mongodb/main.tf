provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "mongodb" {
  ami           = "ami-0e2c8caa4b6378d8c"  # Ganti dengan AMI valid
  instance_type = "t2.micro"
  key_name      = "KEY_CAFE"
  tags = {
    Name = "mongodb-instance"
  }
}
