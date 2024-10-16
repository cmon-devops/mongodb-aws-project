#!/bin/bash
# Combined Script to Create EC2 and Install MongoDB

AMI_ID="ami-011e48799a29115e9"
INSTANCE_TYPE="t2.micro"
KEY_NAME="my-ec2-keypair"
SECURITY_GROUP="my-sg"
KEY_PATH="./my-ec2-keypair.pem"

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

if [ -z "$PUBLIC_DNS" ]; then
    echo "Failed to retrieve Public DNS."
    exit 1
fi

echo "Instance Public DNS: $PUBLIC_DNS"

# Ensure the key has the correct permissions
if [ -f "$KEY_PATH" ]; then
    chmod 400 "$KEY_PATH"
else
    echo "Key file not found: $KEY_PATH"
    exit 1
fi

# SSH into EC2 and install MongoDB
ssh -o "StrictHostKeyChecking=no" -i $KEY_PATH ubuntu@$PUBLIC_DNS << 'EOF'
    sudo apt update
    sudo apt install -y mongodb

    # Start and enable MongoDB service
    sudo systemctl start mongodb
    sudo systemctl enable mongodb

    echo "MongoDB installed and running on EC2 instance."
EOF
