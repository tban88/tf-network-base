######################## DATA: VPC ########################

output "vpc_id" {
  value = aws_vpc.new_vpc.id
}

/*
######################## DATA: SUBNETS ########################

output "prod_prv_subnet_A_data" {
  value = module.prod_prv_subnet_A.id
}

output "prod_prv_subnet_B_data" {
  value = data.aws_subnet.prod_prv_subnet_B_data
}

output "prod_pub_subnet_A_data" {
  value = data.aws_subnet.prod_pub_subnet_A_data
}

output "prod_pub_subnet_B_data" {
  value = data.aws_subnet.prod_pub_subnet_B_data
}

### NONPROD ###

output "nonprod_prv_subnet_A_data" {
  value = data.aws_subnet.nonprod_prv_subnet_A_data
}

output "nonprod_prv_subnet_B_data" {
  value = data.aws_subnet.nonprod_prv_subnet_B_data
}

output "nonprod_pub_subnet_A_data" {
  value = data.aws_subnet.nonprod_pub_subnet_A_data
}

output "nonprod_pub_subnet_B_data" {
  value = data.aws_subnet.nonprod_pub_subnet_B_data
}

######################## DATA: SECURITY GROUPS ########################

### PROD ###

output "prod_df_sg_data" {
  value = data.aws_security_group.prod_df_sg_data
}

output "prod_blank_sg_data" {
  value = aws_security_group.prod_blank_sg.id
}

### NONPROD ###

output "nonprod_df_sg_data" {
  value = data.aws_security_group.nonprod_df_sg_data
}

output "nonprod_blank_sg_data" {
  value = aws_security_group.nonprod_blank_sg.id
}
*/