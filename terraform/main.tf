provider "aws" {
  version = "~> 3.0"
  region  = var.region
  profile = "default"
}

module "vpc" {
  source           = "./modules/vpc"
  region           = var.region
  vpc_cidr         = var.vpc_cidr
  all_access            = var.all_access
  azs              = var.azs
  subnets_cidr_pub = var.subnets_cidr_pub
  subnets_cidr_pvt = var.subnets_cidr_pvt
  subnets_cidr_db  = var.subnets_cidr_db
  tags             = local.common_tags
}

module "security-group" {
  source   = "./modules/security-group"
  vpc_id   = module.vpc.vpc_id
  vpc_cidr = var.vpc_cidr
  all_access     = var.all_access
  tags     = local.common_tags
}