# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# ------------------------------------------------------------------------------
# VPC config
# ------------------------------------------------------------------------------
vpc_cidr                 = "10.10.0.240/28"
vpc_private_subnets      = ["10.10.0.240/28"]
vpc_enable_nat_gateway   = false
vpc_enable_vpn_gateway   = false
vpc_enable_dns_support   = true
vpc_enable_dns_hostnames = true

# ------------------------------------------------------------------------------
# Bastion host config
# ------------------------------------------------------------------------------
instance_type       = "t3.nano"
bastion_host_policy = {
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
  inline_policy       = {}
}

# ------------------------------------------------------------------------------
# Environment config
# ------------------------------------------------------------------------------
target_environment = "dev"
tag_application    = "sandbox"