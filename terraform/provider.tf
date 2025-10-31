
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket = "terraform-state"
    key = "/terraform/terraform.tfstate"
    region = "eu-west-2"
    use_lockfile = true #s3 native locking
  }
}

provider "aws" {
  region = "eu-west-2"
}
