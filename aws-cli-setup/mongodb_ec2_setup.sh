#!/bin/bash
# Script to SSH into EC2 and install MongoDB

PUBLIC_DNS=$(cat ec2_dns.txt)
KEY_PATH="~/.ssh/my-ec2-keypair.pem"  # Path to your key pair

# SSH into EC2 and install MongoDB
ssh -o "StrictHostKeyChecking=no" -i $KEY_PATH ubuntu@$PUBLIC_DNS << 'EOF'
    sudo apt update
    sudo apt install -y mongodb

    # Start and enable MongoDB service
    sudo systemctl start mongodb
    sudo systemctl enable mongodb

    echo "MongoDB installed and running on EC2 instance."
EOF

