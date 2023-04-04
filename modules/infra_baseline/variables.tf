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
  default = {
    "PROD" = {
      cidr_block = "10.10.0.0/16"
      dns        = true
      env        = "PROD"
    },
    "NONPROD" = {
      cidr_block = "10.20.0.0/16"
      dns        = true
      env        = "NONPROD"
    }
  }
}

variable "priv_subnet" {
  type = map(object({
    cidr_block = string
    env        = string
    az         = string
    public     = bool
  }))
  default = {
    "PROD-PRIV-SN-1" = {
      az         = "us-east-1a"
      cidr_block = "10.10.0.0/22"
      env        = "PROD"
      public     = false
    },
    "PROD-PRIV-SN-2" = {
      az         = "us-east-1b"
      cidr_block = "10.10.4.0/22"
      env        = "PROD"
      public     = false
    },
    "NONPROD-PRIV-SN-1" = {
      az         = "us-east-1a"
      cidr_block = "10.20.0.0/22"
      env        = "NONPROD"
      public     = false
    },
    "NONPROD-PRIV-SN-2" = {
      az         = "us-east-1b"
      cidr_block = "10.20.4.0/22"
      env        = "NONPROD"
      public     = false
    }
  }
}

variable "pub_subnet" {
  type = map(object({
    cidr_block = string
    env        = string
    az         = string
    public     = bool
  }))
  default = {
    "PROD-PUB-SN-1" = {
      az         = "us-east-1a"
      cidr_block = "10.10.8.0/22"
      env        = "PROD"
      public     = true
    },
    "PROD-PUB-SN-2" = {
      az         = "us-east-1b"
      cidr_block = "10.10.12.0/22"
      env        = "PROD"
      public     = true
    },
    "NONPROD-PUB-SN-1" = {
      az         = "us-east-1a"
      cidr_block = "10.20.8.0/22"
      env        = "NONPROD"
      public     = true
    },
    "NONPROD-PUB-SN-2" = {
      az         = "us-east-1b"
      cidr_block = "10.20.12.0/22"
      env        = "NONPROD"
      public     = true
    }
  }
}

variable "igw" {
  type = map(object({
    env = string
  }))
  default = {
    "PROD" = {
      env = "PROD"
    },
    "NONPROD" = {
      env = "NONPROD"
    }
  }
}

variable "nat" {
  type = map(object({
    env = string
  }))
  default = {
    "PROD" = {
      env = "PROD"
    },
    "NONPROD" = {
      env = "NONPROD"
    }
  }
}

variable "target_group" {
  type = map(object({
    name            = string
    port            = number
    protocol        = string
    delay           = number
    target_type     = string
    health_port     = number
    health_protocol = string
    health_path     = string
    env             = string
  }))
  default = {
    "PROD-PUB" = {
      delay           = 10
      name            = "PROD-PUB-TG-DEVOPS"
      port            = 80
      protocol        = "HTTP"
      target_type     = "instance"
      health_port     = 80
      health_protocol = "HTTP"
      health_path     = "/"
      env             = "PROD"
    },
    "PROD-PRIV" = {
      delay           = 10
      name            = "PROD-PRIV-TG-DEVOPS"
      port            = 80
      protocol        = "HTTP"
      target_type     = "instance"
      health_port     = 80
      health_protocol = "HTTP"
      health_path     = "/"
      env             = "PROD"
    }
  }
}
