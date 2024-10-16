import argparse

def main(ec2_dns):
    # Your connection logic here
    print(f"Connecting to MongoDB on EC2 instance at {ec2_dns}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Connect to MongoDB on EC2')
    parser.add_argument('--ec2-dns', required=True, help='Public DNS of the EC2 instance')
    args = parser.parse_args()
    main(args.ec2_dns)
