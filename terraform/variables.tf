variable "region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "grafana_ami" {
  description = "AMI ID for the Grafana instance"
  type        = string
  default     = "ami-0e2c8caa4b6378d8c"
}

variable "mongodb_ami" {
  description = "AMI ID for the MongoDB instance"
  type        = string
  default     = "ami-01816d07b1128cd2d"
}

variable "instance_type" {
  description = "Instance type for AWS EC2 instances"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "KEY_CAFE"
}
