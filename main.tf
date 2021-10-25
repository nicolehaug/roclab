provider "aws" {
  version    = "~> 3.20"
  region     = var.region
  assume_role {
    role_arn     = var.role_arn
    session_name = "Research EMR"
  }
}

terraform {
  backend "s3" {
    bucket = "fs-state-nonprod-${var.app_name}"
    key    = "cloudFoundations/state.tfvars"
    region = "us-gov-west-1"
    encrypt = true
    dynamodb_table = "terraform-state-lock-dynamo"
  }
}