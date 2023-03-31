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

resource "aws_eip" "new_nat_eip" {
  for_each = var.nat
  vpc      = true
  tags = {
    Name        = "EIP-${each.key}"
    Environment = each.value["env"]
  }
}

resource "aws_nat_gateway" "new_nat" {
  for_each      = var.nat
  allocation_id = aws_eip.new_nat_eip[each.key]
  subnet_id     = each.value["subnet"]
  tags = {
    Name        = "NAT-${each.key}"
    Environment = each.value["env"]
  }
}