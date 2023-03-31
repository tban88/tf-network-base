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

resource "aws_internet_gateway" "new_igw" {
  for_each = var.igw
  vpc_id   = each.value["vpc"]
  tags = {
    Name        = "IGW-${each.key}"
    Environment = each.value["env"]
  }
}

