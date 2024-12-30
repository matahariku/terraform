variable "region" {
  description = "AWS region for resources"
  default     = "us-east-1"
}

variable "key_pair_name" {
  description = "AWS key pair name for SSH access"
  default     = "KEY_BLOC4"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_public_cidr" {
  description = "CIDR block for the public subnet"
  default     = "10.0.1.0/24"
}

variable "subnet_private_cidr" {
  description = "CIDR block for the private subnet"
  default     = "10.0.2.0/24"
}
