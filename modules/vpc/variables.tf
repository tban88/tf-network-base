variable "region" {
  type    = string
  default = "us-east-1"
}

variable "vpc" {
  type = map(object({
    cidr_block = string
    env        = string
    dns        = bool
  }))
}
