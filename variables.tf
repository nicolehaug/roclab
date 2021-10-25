variable "region" {
  default = "us-gov-west-1"
}

variable "profile" {
    default = "default"
}

variable "app_name" {}

variable "role_arn" {}

variable "app_cidr_az1" {}

variable "app_cidr_az2" {}

variable "lb_cidr_az1" {}

variable "lb_cidr_az2" {}

variable "prefix" {}

variable "vpc_cidr" {}