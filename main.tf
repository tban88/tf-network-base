terraform {
  required_version = ">=1.2"
}

provider "aws" {
  region = var.main_region
}

module "prod_vpc" {
  source          = "./modules/vpc"
  cidr_block      = "10.10.0.0/16"
  vpc_name        = "PROD-VPC"
  vpc_environment = "PROD"
}

module "nonprod_vpc" {
  source          = "./modules/vpc"
  cidr_block      = "10.20.0.0/16"
  vpc_name        = "NONPROD-VPC"
  vpc_environment = "NONPROD"
}

module "prod_pub_sn_1" {
  source            = "./modules/subnet"
  vpc_id            = module.prod_vpc.vpc_id
  cidr_block        = "10.10.8.0/22"
  availability_zone = "us-east-1a"
  public            = true
  subnet_name       = "PROD-PUB-SN-1"
  subnet_env        = "PROD"
}

module "prod_prv_sn_1" {
  source            = "./modules/subnet"
  vpc_id            = module.prod_vpc.vpc_id
  cidr_block        = "10.10.0.0/22"
  availability_zone = "us-east-1b"
  public            = false
  subnet_name       = "PROD-PRV-SN-1"
  subnet_env        = "PROD"
}

/*
module "nonprod_vpc" {
  source = "./modules/vpc"
}

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
