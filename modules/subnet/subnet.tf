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
  for_each                = var.subnet
  vpc_id                  = each.value["vpc"]
  cidr_block              = each.value["cidr_block"]
  availability_zone       = each.value["az"]
  map_public_ip_on_launch = each.value["public"]
  tags = {
    Name        = each.key
    Environment = each.value["env"]
  }
}

# Create routing table for each subnet
resource "aws_route_table" "route_table" {
  for_each = var.subnet
  vpc_id   = each.value["vpc"]
  tags = {
    Name        = "RT-${each.key}"
    Environment = each.value["env"]
  }
}
