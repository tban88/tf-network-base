output "subnet_id" {
  value = { for k, v in aws_subnet.new_subnet : k => v.id }
}
