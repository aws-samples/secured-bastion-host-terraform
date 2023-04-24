# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

output "bastion_vpc_id" {
  value = module.vpc.vpc_id
}

output "bastion_private_subnet_id" {
  value = module.vpc.private_subnets[0]
}

output "vpc_bastion_host_security_group" {
  value = aws_security_group.vpc_bastion_host_security_group.id
}
