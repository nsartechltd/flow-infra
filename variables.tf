variable "aws-profile" {
  description = "Profile used when running terraform command"
}

variable "role" {
  description = "Role to assume when deploying"
}

variable "region" {
  description = "AWS region"
  default     = "eu-west-2"
}

variable "environment" {
  description = "Environment we are deploying to"
}

variable "node_env" {
  description = "Node env to use"
}