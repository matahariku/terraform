output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.nangka.id
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.cafe_public.id
}

output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = aws_subnet.cafe_private.id
}

output "mongodb_instance_ip" {
  description = "The private IP address of the MongoDB instance"
  value       = aws_instance.mongodb.private_ip
}

output "grafana_instance_ip" {
  description = "The public IP address of the Grafana instance"
  value       = aws_instance.grafana.public_ip
}
