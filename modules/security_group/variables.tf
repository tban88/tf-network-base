variable "region" {
  type    = string
  default = "us-east-1"
}

variable "name" {
  type = string
}

variable "description" {
  type = string
}

variable "vpc" {
  type = string
}

variable "ingress_rules" {
  type = list(object({
    port        = number
    description = string
    protocol    = string
    source_ipv4 = list(string)
  }))
}

variable "egress_rules" {
  type = object({
    port             = number
    description      = string
    protocol         = string
    destination_ipv4 = list(string)
  })
  default = {
    description      = "DEFAULT"
    port             = 0
    protocol         = "-1"
    destination_ipv4 = ["0.0.0.0/0"]
  }
}