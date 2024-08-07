provider "aws" {
  region = "eu-west-1"
}

variable "vpc_cidr_block" {}
variable "azs" {}
variable "private_subnets" {}
variable "public_subnets" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.12.0"
  name = "myapp-vpc"
  cidr = var.vpc_cidr_block

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  enable_vpn_gateway = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
  }
  public_subnet_tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
    "kubernetes.io/role/elb" = 1
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}