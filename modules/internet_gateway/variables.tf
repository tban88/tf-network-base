variable "region" {
  type    = string
  default = "us-east-1"
}

variable "igw" {
  type = map(object({
    vpc = string
    env = string
  }))
}