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

resource "aws_security_group" "new_sg" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc

  dynamic "ingress" {
    for_each = var.ingress_rules
    iterator = rule

    content {
      description = rule.value.description
      from_port   = rule.value.port
      to_port     = rule.value.port
      protocol    = rule.value.protocol
      cidr_blocks = rule.value.source_ipv4
    }
  }

  egress {
    from_port   = var.egress_rules.port
    to_port     = var.egress_rules.port
    protocol    = var.egress_rules.protocol
    cidr_blocks = var.egress_rules.destination_ipv4
  }
}