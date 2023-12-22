provider "aws" {
  region  = var.region
  profile = var.aws-profile
  assume_role {
    role_arn = var.role
  }
}

terraform {
  backend "s3" {}
  required_providers {
    postgresql = {
      source = "cyrilgdn/postgresql"
      version = "1.21.1-beta.1"
    }
  }
}