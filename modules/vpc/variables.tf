variable "region" {
  type    = string
  default = "us-east-1"
}

variable "cidr_block" {
  type = string
}

variable "dns_hostnames" {
  type    = bool
  default = true
}

variable "vpc_name" {
  type = string
}

variable "vpc_environment" {
  type = string
}

variable "number_priv_subnets" {
  type    = number
  default = 2
}

variable "number_pub_subnets" {
  type    = number
  default = 2
}

# /22 mask allows for 1022 usable hosts per subnet
variable "cidr_blocks" {
  type = map(any)
  default = {
    "prod-vpc"           = "10.10.0.0/16"
    "prod-prv-cidr-A"    = "10.10.0.0/22"
    "prod-prv-cidr-B"    = "10.10.4.0/22"
    "prod-pub-cidr-A"    = "10.10.8.0/22"
    "prod-pub-cidr-B"    = "10.10.12.0/22"
    "all-ipv4"           = "0.0.0.0/0"
    "all-ipv6"           = "::/0"
    "nonprod-vpc"        = "10.20.0.0/16"
    "nonprod-prv-cidr-A" = "10.20.0.0/22"
    "nonprod-prv-cidr-B" = "10.20.4.0/22"
    "nonprod-pub-cidr-A" = "10.20.8.0/22"
    "nonprod-pub-cidr-B" = "10.20.12.0/22"
  }
}

variable "AZ-names" {
  type = map(any)
  default = {
    "prv-az-A" = "us-east-1a"
    "prv-az-B" = "us-east-1b"
    "pub-az-A" = "us-east-1a"
    "pub-az-B" = "us-east-1b"
  }
}