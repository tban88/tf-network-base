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

locals {
  ingress_rules = [{
    port        = 443
    description = "HTTPS Access"
    protocol    = "tcp"
    },
    {
      port        = 22
      description = "SSH Access"
      protocol    = "tcp"
    },
    {
      port        = 80
      description = "HTTP Access"
      protocol    = "tcp"
    },
    {
      port        = 8080
      description = "JENKINS Access"
      protocol    = "tcp"
  },
    {
      port        = 943
      description = "VPN Admin Access"
      protocol    = "tcp"
  }]
}

resource "aws_vpc" "new_vpc" {
  for_each             = var.vpc
  cidr_block           = each.value["cidr_block"]
  enable_dns_hostnames = each.value["dns"]
  tags = {
    Name        = "VPC-${each.key}"
    Environment = each.value["env"]
  }
}

resource "aws_subnet" "priv_subnet" {
  for_each                = var.priv_subnet
  vpc_id                  = each.value["env"] == "PROD" ? aws_vpc.new_vpc["PROD"].id : aws_vpc.new_vpc["NONPROD"].id
  cidr_block              = each.value["cidr_block"]
  availability_zone       = each.value["az"]
  map_public_ip_on_launch = false
  tags = {
    Name        = each.key
    Environment = each.value["env"]
  }
}

resource "aws_subnet" "pub_subnet" {
  for_each                = var.pub_subnet
  vpc_id                  = each.value["env"] == "PROD" ? aws_vpc.new_vpc["PROD"].id : aws_vpc.new_vpc["NONPROD"].id
  cidr_block              = each.value["cidr_block"]
  availability_zone       = each.value["az"]
  map_public_ip_on_launch = true
  tags = {
    Name        = each.key
    Environment = each.value["env"]
  }
}

resource "aws_route_table" "priv_route_table" {
  for_each = var.priv_subnet
  vpc_id   = each.value["env"] == "PROD" ? aws_vpc.new_vpc["PROD"].id : aws_vpc.new_vpc["NONPROD"].id
  tags = {
    Name        = "RT-${each.key}"
    Environment = each.value["env"]
  }
}

resource "aws_route_table" "pub_route_table" {
  for_each = var.pub_subnet
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
  subnet_id     = each.value["env"] == "PROD" ? aws_subnet.pub_subnet["PROD-PUB-SN-1"].id : aws_subnet.pub_subnet["NONPROD-PUB-SN-1"].id
  tags = {
    Name        = "NAT-${each.key}"
    Environment = each.value["env"]
  }
}

resource "aws_route" "route_igw" {
  for_each               = var.pub_subnet
  route_table_id         = aws_route_table.pub_route_table["${each.key}"].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = each.value["env"] == "PROD" ? aws_internet_gateway.new_igw["PROD"].id : aws_internet_gateway.new_igw["NONPROD"].id
}

resource "aws_route" "route_nat" {
  for_each               = var.priv_subnet
  route_table_id         = aws_route_table.priv_route_table["${each.key}"].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = each.value["env"] == "PROD" ? aws_nat_gateway.new_nat["PROD"].id : aws_nat_gateway.new_nat["NONPROD"].id
}

resource "aws_route_table_association" "priv_route_asoc" {
  for_each       = var.priv_subnet
  subnet_id      = aws_subnet.priv_subnet["${each.key}"].id
  route_table_id = aws_route_table.priv_route_table["${each.key}"].id
}

resource "aws_route_table_association" "pub_route_asoc" {
  for_each       = var.pub_subnet
  subnet_id      = aws_subnet.pub_subnet["${each.key}"].id
  route_table_id = aws_route_table.pub_route_table["${each.key}"].id
}

resource "aws_security_group" "default_sg" {
  for_each    = var.vpc
  name        = "SG-DEFAULT-${each.value["env"]}"
  description = "Allows basic inbound connectivity via HTTP(s) and SSH"
  vpc_id      = aws_vpc.new_vpc["${each.key}"].id

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
  tags = {
    Name        = "SG-DEFAULT-${each.value["env"]}"
    Environment = each.value["env"]
  }
}

resource "aws_security_group" "blank_sg" {
  for_each    = var.vpc
  name        = "SG-BLANK-${each.value["env"]}"
  description = "Used for SSM Instances - No KeyPairs Needed"
  vpc_id      = aws_vpc.new_vpc["${each.key}"].id
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name        = "SG- BLANK-${each.value["env"]}"
    Environment = each.value["env"]
  }
}

resource "aws_lb" "prod_pub_alb" {
  name               = "PUBLIC-ALB-PROD"
  subnets            = ["${aws_subnet.pub_subnet["PROD-PUB-SN-1"].id}", "${aws_subnet.pub_subnet["PROD-PUB-SN-2"].id}"]
  security_groups    = ["${aws_security_group.default_sg["PROD"].id}"]
  internal           = false
  load_balancer_type = "application"
}

resource "aws_lb" "prod_priv_alb" {
  name               = "PRIVATE-ALB-PROD"
  subnets            = ["${aws_subnet.priv_subnet["PROD-PRIV-SN-1"].id}", "${aws_subnet.priv_subnet["PROD-PRIV-SN-2"].id}"]
  security_groups    = ["${aws_security_group.default_sg["PROD"].id}"]
  internal           = true
  load_balancer_type = "application"
}

resource "aws_lb_target_group" "new_tg" {
  for_each             = var.target_group
  name                 = each.value["name"]
  port                 = each.value["port"]
  protocol             = each.value["protocol"]
  vpc_id               = each.value["env"] == "PROD" ? aws_vpc.new_vpc["PROD"].id : aws_vpc.new_vpc["NONPROD"].id
  deregistration_delay = each.value["delay"]
  target_type          = each.value["target_type"]
  health_check {
    port     = each.value["health_port"]
    protocol = each.value["health_protocol"]
    path     = each.value["health_path"]
  }
}

resource "aws_lb_listener" "prod_pub_listener" {
  load_balancer_arn = aws_lb.prod_pub_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.new_tg["PROD-PUB"].arn
  }
}

resource "aws_lb_listener" "prod_priv_listener" {
  load_balancer_arn = aws_lb.prod_priv_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.new_tg["PROD-PRIV"].arn
  }
}

resource "aws_key_pair" "default_key_pair" {
  key_name   = "default"
  public_key = file("./modules/ec2/ssh/test-devops.pub")
}

resource "aws_instance" "ec2_openvpn" {
  ami                         = "ami-04581fbf744a7d11f" #Amazon Linux 2 AMI
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.pub_subnet["PROD-PUB-SN-1"].id
  key_name                    = aws_key_pair.default_key_pair.key_name
  vpc_security_group_ids      = ["${aws_security_group.default_sg["PROD"].id}"]
  user_data                   = file("./modules/ec2/user_data/openvpn_linux2.sh")
  tags = {
    "Name"      = "OPENVPN"
    Environment = "PROD"
  }
  depends_on = [
    aws_key_pair.default_key_pair
  ]
}

