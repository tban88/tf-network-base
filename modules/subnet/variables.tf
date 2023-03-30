variable "region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_id" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "availability_zone" {
  type    = string
  default = "us-east-1a"
}

variable "public" {
  type = bool
}

variable "subnet_name" {
  type = string
}

variable "subnet_env" {
  type = string
}