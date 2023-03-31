variable "region" {
  type    = string
  default = "us-east-1"
}

variable "subnet" {
  type = map(object({
    cidr_block = string
    vpc        = string
    env        = string
    az         = string
    public     = bool
  }))
}