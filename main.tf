provider "aws" {
  region  = var.region
  profile = var.aws-profile
  assume_role {
    role_arn = var.role
  }
}

terraform {
  backend "s3" {}
}