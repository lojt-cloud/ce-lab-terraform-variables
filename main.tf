terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}
resource "aws_s3_bucket" "app_data" {
  bucket = "ce-lab-dev-app-data-12345"
}
resource "aws_security_group" "app_sg" {
  name        = "ce-lab-dev-sg"
  description = "Security group for dev app servers"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "app_server" {
  ami                    = "ami-0abcdef1234567890"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = {
    Name = "ce-lab-dev-app-1"
  }
}