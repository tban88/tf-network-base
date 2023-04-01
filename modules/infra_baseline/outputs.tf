######################## DATA: VPC ########################

output "vpc_id" {
  value = { for k, v in aws_vpc.new_vpc : k => v.id }
}

output "subnet_id" {
  value = { for k, v in aws_subnet.new_subnet : k => v.id }
}

output "route_id" {
  value = { for k, v in aws_route_table.route_table : k => v.id }
}

output "igw_id" {
  value = { for k, v in aws_internet_gateway.new_igw : k => v.id }
}

output "eip_id" {
  value = { for k, v in aws_eip.new_nat_eip : k => v.id }
}

output "nat_id" {
  value = { for k, v in aws_nat_gateway.new_nat : k => v.id }
}