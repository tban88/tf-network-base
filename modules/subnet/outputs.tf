output "subnet_id" {
  value = { for k, v in aws_subnet.new_subnet : k => v.id }
}

output "route_id" {
  value = { for k, v in aws_route_table.route_table : k => v.id }
}
