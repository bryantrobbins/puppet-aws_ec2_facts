#!/bin/bash

AZ=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
echo "ec2_availability_zone=${AZ}"

REGION="`echo \"$AZ\" | sed -e 's:\([0-9][0-9]*\)[a-z]*\$:\\1:'`"
echo "ec2_region=${REGION}"

MYID=`curl -s http://169.254.169.254/latest/meta-data/instance-id`
LOGICAL_JSON=`aws --region ${REGION} ec2 describe-tags --filters "Name=resource-id,Values=${MYID}" "Name=key,Values=aws:cloudformation:logical-id"`
LOGICAL_ID=`echo "${LOGICAL_JSON}" | grep Value | tr -d ' ,:"' | sed 's/^.\{5\}//'`
echo "ec2_cloudformation_logical_id=${LOGICAL_ID}"
