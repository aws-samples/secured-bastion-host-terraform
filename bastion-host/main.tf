# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

resource "aws_instance" "bastion_host_ec2_instance" {
  ami                     = data.aws_ami.amazon-linux-2.id
  instance_type           = var.instance_type
  subnet_id               = var.subnet_id
  vpc_security_group_ids  = var.bastion_host_security_group_ids
  iam_instance_profile    = aws_iam_instance_profile.bastion-host-instance-profile.name
  disable_api_termination = true

  root_block_device {
    encrypted = true
  }

  #checkov:skip=CKV_AWS_135:t3.nano have ebs_optimization enabled by default
  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-optimized.html
  monitoring = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  tags = {
    Name = "${var.tag_application}-${var.target_environment}-bastion-host"
  }
}
