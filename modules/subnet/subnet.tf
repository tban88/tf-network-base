######################## TERRAFORM CONFIG ########################

terraform {
  required_version = ">=1.2"
}

######################## PROVIDERS ########################

# Define provided: AWS
provider "aws" {
  region = var.region
}

######################## RESOURCES ########################

resource "aws_subnet" "new_subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = var.public
  tags = {
    Name        = var.subnet_name
    Environment = var.subnet_env
  }
}
/*
# Create routing tables to route traffic for Private Subnet - PROD
resource "aws_route_table" "prod_prv_rt" {
  vpc_id = var.vpc_id
  tags   = {
    Name = "RT-"+var.subnet_name
  }
}
*/