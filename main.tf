terraform {
  required_version = ">=1.2"
}

provider "aws" {
  region = var.main_region
}

module "infra_baseline" {
  source = "./modules/infra_baseline"
}

/*
module "prod_sg" {
  source      = "./modules/security_group"
  name        = "TEST-SG"
  description = "No Description"
  vpc         = local.prod_vpc_id
  ingress_rules = [{
    port        = 80
    description = "HTTP Access"
    protocol    = "tcp"
    source_ipv4 = ["0.0.0.0/0"]
    },
    {
      port        = 443
      description = "HTTPS Access"
      protocol    = "tcp"
      source_ipv4 = ["0.0.0.0/0"]
  }]
}

module "prod_pub_lb" {
  source           = "./modules/alb/prod"
  prod_prv_subnets = local.prod_prv_subnets
  prod_pub_subnets = local.prod_pub_subnets
  prod_default_sg  = local.prod_default_sg
  prod_vpc         = local.prod_vpc_id
  lb_name          = "PROD-WEB-PUBLIC"
  internal         = false
}

module "prod_priv_lb" {
  source           = "./modules/alb/prod"
  prod_prv_subnets = local.prod_prv_subnets
  prod_pub_subnets = local.prod_pub_subnets
  prod_default_sg  = local.prod_default_sg
  prod_vpc         = local.prod_vpc_id
  lb_name          = "PROD-WEB-PRIVATE"
  internal         = true
}

module "ec2-openvpn" {
  source            = "./modules/ec2"
  vpc_id            = module.vpc.prod_vpc_data.id
  subnet_id         = module.vpc.prod_pub_subnet_A_data.id
  security_group_id = module.vpc.prod_df_sg_data.id
  ami_id            = "ami-08d4ac5b634553e16" #ubuntu 20.04
  user_data         = "./modules/ec2/user_data/openvpn_linux2.sh"
  ec2_name          = "OPENVPN"
  public_ip         = true
}
*/
