#!/bin/bash
# Script to create an EC2 instance using AWS CLI

AMI_ID="ami-00541bdde421799c7"
INSTANCE_TYPE="t2.micro"
KEY_NAME="my-ec2-keypair"
SECURITY_GROUP="my-sg"

# Create a Security Group that allows SSH and MongoDB access (port 27017)
aws ec2 create-security-group --group-name $SECURITY_GROUP --description "Security group for MongoDB"

# Add rules to Security Group
aws ec2 authorize-security-group-ingress --group-name $SECURITY_GROUP --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-name $SECURITY_GROUP --protocol tcp --port 27017 --cidr 0.0.0.0/0

# Launch EC2 instance
INSTANCE_ID=$(aws ec2 run-instances \
    --image-id $AMI_ID \
    --count 1 \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-groups $SECURITY_GROUP \
    --query 'Instances[0].InstanceId' \
    --output text)

echo "Instance created with ID: $INSTANCE_ID"

# Wait until instance is running
aws ec2 wait instance-running --instance-ids $INSTANCE_ID

# Get public DNS of the instance
PUBLIC_DNS=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PublicDnsName' --output text)

echo "Instance Public DNS: $PUBLIC_DNS"

echo "EC2 instance created. Now run the 'mongodb_ec2_setup.sh' script to configure MongoDB on the instance."

