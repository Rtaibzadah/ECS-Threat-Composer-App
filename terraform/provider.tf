
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket = "terraform-state-roman"
    key = "terraform.tfstate"
    region = "eu-west-2"
    use_lockfile = true #s3 native locking
    profile      = "easyecs" 
  }
}

provider "aws" {
  region = "eu-west-2"
  profile = "easyecs"
}
