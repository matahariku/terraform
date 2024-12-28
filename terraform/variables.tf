variable "region" {
  description = "Region AWS untuk deployment"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block untuk VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block untuk subnet publik"
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block untuk subnet privat"
  default     = "10.0.2.0/24"
}

variable "grafana_ami" {
  description = "AMI ID untuk instance Grafana"
  type        = string
  default     = "ami-0e2c8caa4b6378d8c" 
}

variable "mongodb_ami" {
  description = "AMI ID untuk instance MongoDB"
  type        = string
  default     = "ami-01816d07b1128cd2d"  
}

variable "instance_type" {
  description = "Tipe instance AWS"
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key pair untuk akses SSH"
}



