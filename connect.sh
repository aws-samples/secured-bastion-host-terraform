#!/usr/bin/env bash
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

set -e
BASTION_HOST_TAG=$1
KEY_NAME=$2
ssh-keygen -t rsa -f "$KEY_NAME"
INSTANCE_ID=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$BASTION_HOST_TAG" --output text --query 'Reservations[*].Instances[*].InstanceId' --output text)
aws ec2-instance-connect send-ssh-public-key --instance-id "$INSTANCE_ID" --instance-os-user ec2-user --ssh-public-key "file://$KEY_NAME.pub"
exec ssh -i "$KEY_NAME" "ec2-user@$INSTANCE_ID"
