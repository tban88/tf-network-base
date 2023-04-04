######################## DATA: VPC ########################

output "vpc_id" {
  value = { for k, v in aws_vpc.new_vpc : k => v.id }
}

output "pub_subnet_id" {
  value = { for k, v in aws_subnet.pub_subnet : k => v.id }
}

output "priv_subnet_id" {
  value = { for k, v in aws_subnet.priv_subnet : k => v.id }
}

output "pub_route_id" {
  value = { for k, v in aws_route_table.pub_route_table : k => v.id }
}

output "priv_route_id" {
  value = { for k, v in aws_route_table.pub_route_table : k => v.id }
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

output "default_sg_id" {
  value = { for k, v in aws_security_group.default_sg : k => v.id }
}

output "prod_pub_alb_arn" {
  value = aws_lb.prod_pub_alb.arn
}

output "prod_priv_alb_arn" {
  value = aws_lb.prod_priv_alb.arn
}

output "target_group_arn" {
  value = { for k, v in aws_lb_target_group.new_tg : k => v.id }
}

output "ec2_openvpn_id" {
  value = aws_instance.ec2_openvpn.id
}