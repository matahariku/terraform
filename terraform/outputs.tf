output "grafana_instance_id" {
  description = "ID instance Grafana"
  value       = aws_instance.grafana.id
}

output "mongodb_instance_id" {
  description = "ID instance MongoDB"
  value       = aws_instance.mongodb.id
}

output "grafana_public_ip" {
  description = "Alamat IP publik instance Grafana"
  value       = aws_instance.grafana.public_ip
}

output "mongodb_private_ip" {
  description = "Alamat IP privat instance MongoDB"
  value       = aws_instance.mongodb.private_ip
}

output "vpc_id" {
  description = "ID VPC yang dibuat"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID subnet publik"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID subnet privat"
  value       = aws_subnet.private.id
}
