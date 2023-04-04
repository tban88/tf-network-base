######################## DATA: VPC ########################

output "VPC-IDs" {
  value = module.infra_baseline.vpc_id
}

output "PRIV-SUBNET-IDs" {
  value = module.infra_baseline.priv_subnet_id
}

output "PUB-SUBNET-IDs" {
  value = module.infra_baseline.pub_subnet_id
}

output "EC2-OPENVPN-ID" {
  value = module.infra_baseline.ec2_openvpn_id
}

/*
output "IGW-IDs" {
  value = module.infra_baseline.igw_id
}

output "EIP-IDs" {
  value = module.infra_baseline.eip_id
}

output "NAT-IDs" {
  value = module.infra_baseline.nat_id
}

output "DEFAULT-SG-IDs" {
  value = module.infra_baseline.default_sg_id
}

output "PROD-PUB-ALB-ARN" {
  value = module.infra_baseline.prod_pub_alb_arn
}

output "PROD-PRIV-ALB-ARN" {
  value = module.infra_baseline.prod_priv_alb_arn
}

output "TARGET-GROUP-ARN" {
  value = module.infra_baseline.target_group_arn
}

output "EC2-OPENVPN-ID" {
  value = module.infra_baseline.ec2_openvpn_id
}

*/