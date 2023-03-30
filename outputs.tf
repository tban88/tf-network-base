######################## DATA: VPC ########################

output "VPC_PROD_ID" {
  value = module.prod_vpc.vpc_id
}

output "VPC_NONPROD_ID" {
  value = module.nonprod_vpc.vpc_id
}

######################## DATA: SUBNETS ########################

output "SUBNET_PROD_PUB_1" {
  value = module.prod_pub_sn_1.subnet_id
}

output "SUBNET_PROD_PRV_1" {
  value = module.prod_prv_sn_1.subnet_id
}

/*
### NONPROD ###

output "data_nonprod_prv_subnet_A_id" {
  value = module.vpc.nonprod_prv_subnet_A_data.id
}

output "data_nonprod_prv_subnet_B_id" {
  value = module.vpc.nonprod_prv_subnet_B_data.id
}

output "data_nonprod_pub_subnet_A_id" {
  value = module.vpc.nonprod_pub_subnet_A_data.id
}

output "data_nonprod_pub_subnet_B_id" {
  value = module.vpc.nonprod_pub_subnet_B_data.id
}

######################## DATA: SECURITY GROUPS ########################

### PROD ###

output "data_prod_df_sg_id" {
  value = module.vpc.prod_df_sg_data.id
}

### NONPROD ###

output "data_nonprod_df_sg_id" {
  value = module.vpc.nonprod_df_sg_data.id
}

######################## DATA: ELB ########################

output "prod_alb_public_arn" {
  value = module.prod_pub_lb.lb_arn
}

output "prod_alb_private_arn" {
  value = module.prod_priv_lb.lb_arn
}

output "prod_alb_public_dns" {
  value = module.prod_pub_lb.dns_url
}
*/