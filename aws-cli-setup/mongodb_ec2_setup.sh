#!/bin/bash
# Script to SSH into EC2 and install MongoDB

PUBLIC_DNS=ec2-107-22-52-187.compute-1.amazonaws.com
KEY_PATH="../mongodb-app/my-ec2-keypair.pem"
chmod 400 $KEY_PATH

# SSH into EC2 and install MongoDB
ssh -o "StrictHostKeyChecking=no" -i $KEY_PATH ubuntu@$PUBLIC_DNS << 'EOF'
    sudo apt update
    sudo apt install -y mongodb

    # Start and enable MongoDB service
    sudo systemctl start mongodb
    sudo systemctl enable mongodb

    echo "MongoDB installed and running on EC2 instance."
EOF

