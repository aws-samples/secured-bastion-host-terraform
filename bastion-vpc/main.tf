# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

module "vpc" {
  source     = "terraform-aws-modules/vpc/aws"
  version    = "~> 4.0"
  create_vpc = true

  name = "bastion-host-vpc"

  cidr            = var.vpc_cidr
  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets

  enable_nat_gateway   = var.vpc_enable_nat_gateway
  enable_vpn_gateway   = var.vpc_enable_vpn_gateway
  enable_dns_support   = var.vpc_enable_dns_support
  enable_dns_hostnames = var.vpc_enable_dns_hostnames

  flow_log_file_format = "parquet"
  tags = {
    Name = "${var.tag_application}-${var.target_environment}-bastion-host"
  }
}

###################################################################
# SSM Messages VPC endpoint
###################################################################
resource "aws_security_group" "vpc_bastion_host_security_group" {
  #checkov:skip=CKV2_AWS_5:SG is used in VPC Endpoint and will be used by EC2 but not in this module
  name        = "vpc-bastion-host-security-group"
  description = "Security group for bastion host"
  vpc_id      = module.vpc.vpc_id
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "Allow traffic on all ports and ip ranges"
  }
}


resource "aws_vpc_endpoint" "vpc_ssmmessages_vpce" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnets
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.vpc_ssmmessages_vpce_security_group.id]

  tags = {
    Name = "${var.tag_application}-${var.target_environment}-vpc-ssmmessages-vpce"
  }
}

resource "aws_security_group" "vpc_ssmmessages_vpce_security_group" {
  name        = "vpc-ssmmessages-security-group"
  description = "Security group for SSM Messages VPC endpoint"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "vpc_ssmmessages_vpce_security_group_ingress_rule" {
  security_group_id        = aws_security_group.vpc_ssmmessages_vpce_security_group.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 443
  to_port                  = 443
  source_security_group_id = aws_security_group.vpc_bastion_host_security_group.id
  description              = "vpc ssm messages vpce security group ingress rule"
}

###################################################################
# EC2 Messages VPC endpoint
###################################################################

resource "aws_vpc_endpoint" "vpc_ec2messages_vpce" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnets
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.vpc_ec2messages_vpce_security_group.id]

  tags = {
    Name = "${var.tag_application}-${var.target_environment}-vpc-ec2messages-vpce"
  }
}

resource "aws_security_group" "vpc_ec2messages_vpce_security_group" {
  name        = "vpc-ec2messages-security-group"
  description = "Security group for EC2 Messages VPC endpoint"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "vpc_ec2messages_vpce_security_group_ingress_rule" {
  security_group_id        = aws_security_group.vpc_ec2messages_vpce_security_group.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 443
  to_port                  = 443
  source_security_group_id = aws_security_group.vpc_bastion_host_security_group.id
  description              = "vpc ec2 messages vpce security group ingress rule"
}

###################################################################
# SSM VPC endpoint
###################################################################
#
resource "aws_vpc_endpoint" "vpc_ssm_vpce" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnets
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.vpc_ssm_vpce_security_group.id]

  tags = {
    Name = "${var.tag_application}-${var.target_environment}-vpc-ssm-vpce"
  }
}

resource "aws_security_group" "vpc_ssm_vpce_security_group" {
  name        = "vpc-ssm-security-group"
  description = "Security group for SSM VPC endpoint"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "vpc_ssm_vpce_security_group_bastion_host_ingress_rule" {
  security_group_id        = aws_security_group.vpc_ssm_vpce_security_group.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 443
  to_port                  = 443
  source_security_group_id = aws_security_group.vpc_bastion_host_security_group.id
  description              = "vpc ssm vpce security group ingress rule for bastion host"
}

