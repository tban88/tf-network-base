output "eip_id" {
  value = { for k, v in aws_eip.new_nat_eip : k => v.id }
}

output "nat_id" {
  value = { for k, v in aws_nat_gateway.new_nat : k => v.id }
}