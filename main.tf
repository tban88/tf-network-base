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

module "infra_baseline" {
  source = "./modules/infra_baseline"
}