# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# ------------------------------------------------------------------------------
# VPC host module
# ------------------------------------------------------------------------------
module "bastion-vpc" {
  source                   = "./bastion-vpc"
  vpc_enable_nat_gateway   = var.vpc_enable_nat_gateway
  vpc_enable_dns_hostnames = var.vpc_enable_dns_hostnames
  vpc_enable_dns_support   = var.vpc_enable_dns_support
  vpc_enable_vpn_gateway   = var.vpc_enable_vpn_gateway
  vpc_cidr                 = var.vpc_cidr
  vpc_private_subnets      = var.vpc_private_subnets
  vpc_azs                  = [data.aws_availability_zones.available.names[0]]
  aws_region               = data.aws_region.current.name
  target_environment       = var.target_environment
  tag_application          = var.tag_application
}

# ------------------------------------------------------------------------------
# Bastion host module
# ------------------------------------------------------------------------------
module "bastion-host" {
  source                          = "./bastion-host"
  tag_application                 = var.tag_application
  target_environment              = var.target_environment
  subnet_id                       = module.bastion-vpc.bastion_private_subnet_id
  bastion_host_security_group_ids = [module.bastion-vpc.vpc_bastion_host_security_group]
  instance_type                   = var.instance_type
  bastion_host_policy             = var.bastion_host_policy
}
