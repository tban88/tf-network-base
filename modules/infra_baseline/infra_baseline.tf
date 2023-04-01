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

resource "aws_vpc" "new_vpc" {
  for_each             = var.vpc
  cidr_block           = each.value["cidr_block"]
  enable_dns_hostnames = each.value["dns"]
  tags = {
    Name        = "VPC-${each.key}"
    Environment = each.value["env"]
  }
}

resource "aws_subnet" "new_subnet" {
  for_each                = var.subnet
  vpc_id                  = each.value["env"] == "PROD" ? aws_vpc.new_vpc["PROD"].id : aws_vpc.new_vpc["NONPROD"].id
  cidr_block              = each.value["cidr_block"]
  availability_zone       = each.value["az"]
  map_public_ip_on_launch = each.value["public"]
  tags = {
    Name        = each.key
    Environment = each.value["env"]
  }
}

resource "aws_route_table" "route_table" {
  for_each = var.subnet
  vpc_id   = each.value["env"] == "PROD" ? aws_vpc.new_vpc["PROD"].id : aws_vpc.new_vpc["NONPROD"].id
  tags = {
    Name        = "RT-${each.key}"
    Environment = each.value["env"]
  }
}

resource "aws_internet_gateway" "new_igw" {
  for_each = var.igw
  vpc_id   = each.value["env"] == "PROD" ? aws_vpc.new_vpc["PROD"].id : aws_vpc.new_vpc["NONPROD"].id
  tags = {
    Name        = "IGW-${each.key}"
    Environment = each.value["env"]
  }
}

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
  allocation_id = each.value["env"] == "PROD" ? aws_eip.new_nat_eip["PROD"].id : aws_eip.new_nat_eip["NONPROD"].id
  subnet_id     = each.value["env"] == "PROD" ? aws_subnet.new_subnet["PROD-PUB-SN-1"].id : aws_subnet.new_subnet["NONPROD-PUB-SN-1"].id
  tags = {
    Name        = "NAT-${each.key}"
    Environment = each.value["env"]
  }
}

resource "aws_route" "route_igw" {
  for_each               = var.pub_subnet
  route_table_id         = aws_route_table.route_table["${each.key}"].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = each.value["env"] == "PROD" ? aws_internet_gateway.new_igw["PROD"].id : aws_internet_gateway.new_igw["NONPROD"].id
}

resource "aws_route" "route_nat" {
  for_each               = var.priv_subnet
  route_table_id         = aws_route_table.route_table["${each.key}"].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = each.value["env"] == "PROD" ? aws_nat_gateway.new_nat["PROD"].id : aws_nat_gateway.new_nat["NONPROD"].id
}

resource "aws_route_table_association" "priv_route_asoc" {
  for_each       = var.priv_subnet
  subnet_id      = aws_subnet.new_subnet["${each.key}"].id
  route_table_id = aws_route_table.route_table["${each.key}"].id
}

resource "aws_route_table_association" "pub_route_asoc" {
  for_each       = var.pub_subnet
  subnet_id      = aws_subnet.new_subnet["${each.key}"].id
  route_table_id = aws_route_table.route_table["${each.key}"].id
}

/*
# Default Security Group of VPC
resource "aws_security_group" "prod_default_sg" {
  name        = "PROD-DEFAULT-SG"
  description = "Allows basic inbound connectivity via HTTP(s) and SSH"
  vpc_id      = aws_vpc.prod_vpc.id
  depends_on = [
    aws_vpc.prod_vpc
  ]

  dynamic "ingress" {
    for_each = local.ingress_rules
    iterator = rule

    content {
      description = rule.value.description
      from_port   = rule.value.port
      to_port     = rule.value.port
      protocol    = rule.value.protocol
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = var.prod_df_sg_tags
}

# Blank Security Group for PROD VPC
resource "aws_security_group" "prod_blank_sg" {
  name        = "PROD-BLANK-SG"
  description = "Used for SSM Instances - No KeyPairs Needed"
  vpc_id      = aws_vpc.prod_vpc.id
  depends_on = [
    aws_vpc.prod_vpc
  ]
}

######################## RESOURCES: NONPROD ########################

# Default Security Group for NONPROD VPC
resource "aws_security_group" "nonprod_default_sg" {
  name        = "NONPROD-DEFAULT-SG"
  description = "Allows basic inbound connectivity via HTTP(s) and SSH"
  vpc_id      = aws_vpc.nonprod_vpc.id
  depends_on = [
    aws_vpc.nonprod_vpc
  ]

  dynamic "ingress" {
    for_each = local.ingress_rules
    iterator = rule

    content {
      description = rule.value.description
      from_port   = rule.value.port
      to_port     = rule.value.port
      protocol    = rule.value.protocol
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
 
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = var.nonprod_df_sg_tags
}

# Blank Security Group for NONPROD VPC
resource "aws_security_group" "nonprod_blank_sg" {
  name        = "NONPROD-BLANK-SG"
  description = "Used for SSM Instances - No KeyPairs Needed"
  vpc_id      = aws_vpc.nonprod_vpc.id
  depends_on = [
    aws_vpc.nonprod_vpc
  ]
}
*/