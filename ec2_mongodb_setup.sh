#!/bin/bash

# Variables
KEY_PATH="secret.pem"  # Path to your key pair
INSTANCE_TYPE="t2.micro"          # Specify the instance type
AMI_ID="ami-011e48799a29115e9"    # Specify the AMI ID (Ubuntu 20.04 in this case)
SECURITY_GROUP="sg-020703650cac4139d"  # Replace with your security group ID

# Ensure the key has the correct permissions
if [ -f "$KEY_PATH" ]; then
    chmod 400 "$KEY_PATH"
else
    echo "Key file not found: $KEY_PATH"
    exit 1
fi

# Create EC2 instance and capture the Public DNS
INSTANCE_INFO=$(aws ec2 run-instances --image-id $AMI_ID --count 1 --instance-type $INSTANCE_TYPE --key-name "my-ec2-keypair" --security-group-ids $SECURITY_GROUP --query "Instances[0].[PublicDnsName]" --output text)

if [ -z "$INSTANCE_INFO" ]; then
    echo "Failed to create EC2 instance."
    exit 1
fi

PUBLIC_DNS=$INSTANCE_INFO
echo "EC2 instance created with Public DNS: $PUBLIC_DNS"

# Output the public DNS to a file
echo $PUBLIC_DNS > ec2_dns.txt

# SSH into EC2 and install MongoDB
ssh -o "StrictHostKeyChecking=no" -i $KEY_PATH ubuntu@$PUBLIC_DNS << 'EOF'
    sudo apt update
    sudo apt install -y mongodb

    # Start and enable MongoDB service
    sudo systemctl start mongodb
    sudo systemctl enable mongodb

    echo "MongoDB installed and running on EC2 instance."
EOF
