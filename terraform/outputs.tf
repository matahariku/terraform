output "grafana_instance_public_ip" {
  description = "Public IP dari instance Grafana"
  value       = aws_instance.grafana_instance.public_ip
}

output "mongodb_instance_private_ip" {
  description = "Private IP dari instance MongoDB"
  value       = aws_instance.mongodb_instance.private_ip
}

output "vpc_id" {
  description = "ID dari VPC"
  value       = aws_vpc.nangka_vpc.id
}

output "public_subnet_id" {
  description = "ID dari subnet publik"
  value       = aws_subnet.cafe_public.id
}

output "private_subnet_id" {
  description = "ID dari subnet privat"
  value       = aws_subnet.cafe_private.id
}

output "security_group_grafana" {
  description = "ID dari Security Group Grafana"
  value       = aws_security_group.sg_grafana.id
}

output "security_group_mongodb" {
  description = "ID dari Security Group MongoDB"
  value       = aws_security_group.sg_mongodb.id
}
