# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

variable "target_environment" {}

variable "tag_application" {}

variable "subnet_id" {}

variable "bastion_host_security_group_ids" {}

variable "instance_type" {}

variable "bastion_host_policy" {
  type = object({
    managed_policy_arns = list(string)
    inline_policy       = map(any)
  })
}
