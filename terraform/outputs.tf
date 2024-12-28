output "grafana_instance_id" {
  description = "ID de l'instance Grafana"
  value       = aws_instance.grafana.id
}

output "mongodb_instance_id" {
  description = "ID de l'instance MongoDB"
  value       = aws_instance.mongodb.id
}

output "grafana_public_ip" {
  description = "Adresse IP publique de l'instance Grafana"
  value       = aws_instance.grafana.public_ip
}

output "mongodb_private_ip" {
  description = "Adresse IP privée de l'instance MongoDB"
  value       = aws_instance.mongodb.private_ip
}

output "vpc_id" {
  description = "ID du VPC créé"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID du sous-réseau public"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID du sous-réseau privé"
  value       = aws_subnet.private.id
}
