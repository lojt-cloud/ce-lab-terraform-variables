# prod.tfvars

environment = "prod"
aws_region = "us-east-1"
instance_type = "t3.medium"
sg_name = "ce-lab-sg"
ssh_cidr_blocks = ["10.0.0.0/16"]