variable "region" {
  type    = string
  default = "us-east-1"
}

variable "nat" {
  type = map(object({
    subnet = string
    env    = string
  }))
}