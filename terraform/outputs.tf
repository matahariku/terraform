output "vpc_id" {
  value       = aws_vpc.nangka.id
  description = "ID of the VPC"
}

output "public_subnet_id" {
  value       = aws_subnet.cafe_public.id
  description = "ID of the public subnet"
}

output "private_subnet_id" {
  value       = aws_subnet.cafe_private.id
  description = "ID of the private subnet"
}

output "internet_gateway_id" {
  value       = aws_internet_gateway.gw_nangka.id
  description = "ID of the Internet Gateway"
}

output "route_table_id" {
  value       = aws_route_table.route_private.id
  description = "ID of the route table"
}

output "sg_grafana_id" {
  value       = aws_security_group.sg_grafana.id
  description = "ID of the Grafana Security Group"
}

output "sg_mongodb_id" {
  value       = aws_security_group.sg_mongodb.id
  description = "ID of the MongoDB Security Group"
}
