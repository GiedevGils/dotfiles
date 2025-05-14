#!/bin/bash

if ! type "session-manager-plugin" > /dev/null; then
  echo "aws ssm session-manager-plugin not installed"
  echo "install it from https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html"
  exit 1;
fi

if [ -z "$1" ]; then
  echo "usage: awssh <instance name>"
  exit 1;
fi

instanceId=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=$1" "Name=instance-state-name,Values=running" \
  --query "Reservations[].Instances[].InstanceId" \
  --profile=dsp \
  --output=json \
  --region=eu-north-1 \
  | jq -r '.[0]'
)

if [ -z $instanceId ]; then
  echo "no instance found"
  exit 1;
fi

aws ssm start-session --target=$instanceId --profile=dsp --region=eu-north-1
