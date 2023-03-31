terraform {
  required_version = ">=1.2"
}

provider "aws" {
  region = var.main_region
}

locals {
  vpc = {
    PROD    = { cidr_block = "10.10.0.0/16", env = "PROD", dns = true },
    NONPROD = { cidr_block = "10.20.0.0/16", env = "NONPROD", dns = false },
  }

  subnet = {
    PROD-PRIV-SN-1    = { cidr_block = "10.10.0.0/22", vpc = module.vpc.vpc_id["PROD"], env = "PROD", az = "us-east-1a", public = false },
    PROD-PRIV-SN-2    = { cidr_block = "10.10.4.0/22", vpc = module.vpc.vpc_id["PROD"], env = "PROD", az = "us-east-1b", public = false },
    PROD-PUB-SN-1     = { cidr_block = "10.10.8.0/22", vpc = module.vpc.vpc_id["PROD"], env = "PROD", az = "us-east-1a", public = true },
    PROD-PUB-SN-2     = { cidr_block = "10.10.12.0/22", vpc = module.vpc.vpc_id["PROD"], env = "PROD", az = "us-east-1b", public = true },
    NONPROD-PRIV-SN-1 = { cidr_block = "10.20.0.0/22", vpc = module.vpc.vpc_id["NONPROD"], env = "NONPROD", az = "us-east-1a", public = false },
    NONPROD-PRIV-SN-2 = { cidr_block = "10.20.4.0/22", vpc = module.vpc.vpc_id["NONPROD"], env = "NONPROD", az = "us-east-1b", public = false },
    NONPROD-PUB-SN-1  = { cidr_block = "10.20.8.0/22", vpc = module.vpc.vpc_id["NONPROD"], env = "NONPROD", az = "us-east-1a", public = true },
    NONPROD-PUB-SN-2  = { cidr_block = "10.20.12.0/22", vpc = module.vpc.vpc_id["NONPROD"], env = "NONPROD", az = "us-east-1b", public = true }
  }

  nat = {
    PROD    = { subnet = module.subnet.subnet_id["PROD-PUB-SN-1"].subnet_id, env = "PROD" },
    NONPROD = { subnet = module.subnet.subnet_id["PROD-PUB-SN-1"].subnet_id, env = "NONPROD" }
  }
}

module "vpc" {
  source = "./modules/vpc"
  vpc    = local.vpc
}

module "subnet" {
  source = "./modules/subnet"
  subnet = local.subnet
}

module "igw" {
  source = "./modules/internet_gateway"
    igw = {
    PROD    = { vpc = module.vpc.vpc_id["PROD"].vpc_id, env = "PROD" },
    NONPROD = { vpc = module.vpc.vpc_id["NONPROD"].vpc_id, env = "NONPROD" }
  }
}

module "nat" {
  source = "./modules/nat_gateway"
  nat    = local.nat
}

/*
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
*/
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
