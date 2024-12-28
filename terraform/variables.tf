variable "grafana_ami" {
  description = "AMI ID untuk Grafana (Ubuntu)"
  type        = string
}

variable "mongodb_ami" {
  description = "AMI ID untuk MongoDB (Amazon Linux)"
  type        = string
}

variable "instance_type" {
  description = "Tipe instance AWS"
  type        = string
  default     = "t2.micro"
}
