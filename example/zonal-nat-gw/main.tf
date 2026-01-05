terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.26"
    }
  }
}

data "aws_availability_zones" "available" {}

provider "aws" {
  region = "eu-central-1"
}

module "vpc" {
  source = "../../../terraform-aws-vpc"

  vpc_cidr = "10.0.0.0/16"
  public_subnet_cidr = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidr = ["10.0.11.0/24", "10.0.12.0/24"]
  public_subnet = slice(data.aws_availability_zones.available.names,0,2)
  private_subnet = slice(data.aws_availability_zones.available.names,0,2)
  nat_gw = true
  single_az_nat = true
}