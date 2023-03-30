######################## INCOMING PARAMETERS ########################

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "internal" {
  type        = bool
  description = "LB is private or not | true = internal | false = public"
  default     = false
}

variable "lb_name" {
  type        = string
  description = "LB's name"
}

variable "lb_type" {
  type        = string
  description = "LB type: gateway, application, network"
  default     = "application"
}

variable "prod_prv_subnets" {
  type = list(any)
}

variable "prod_pub_subnets" {
  type = list(any)
}

variable "prod_default_sg" {
  type = list(any)
}

variable "prod_vpc" {
  type = string
}
