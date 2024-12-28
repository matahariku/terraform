variable "grafana_ami" {
  description = "AMI ID untuk instance Grafana"
  type        = string
}

variable "mongodb_ami" {
  description = "AMI ID untuk instance MongoDB"
  type        = string
}

variable "instance_type" {
  description = "Tipe instance AWS"
  type        = string
  default     = "t2.micro"
}

variable "vpc_cidr" {
  description = "CIDR block untuk VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block untuk subnet publik"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block untuk subnet privat"
  type        = string
  default     = "10.0.2.0/24"
}

variable "region" {
  description = "AWS Region untuk deploy"
  type        = string
}

variable "key_name" {
  description = "Key pair untuk akses SSH"
  type        = string
}
