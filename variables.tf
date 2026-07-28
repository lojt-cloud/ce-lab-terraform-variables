variable "aws_region" {
  description = "AWS region the deployment will go to"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment name (used for naming/tagging)"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "ssh_cidr_blocks" {
description = "Securit group cidr_blocks"
type        = list(string)
default     = ["0.0.0.0/0"]
}

variable "instance_type" {
  description = "EC2 instance type for the app server"
  type        = string
  default     = "t3.micro"

  validation {
    condition     = contains(["t3.micro", "t3.small", "t3.medium", "t3.large"], var.instance_type)
    error_message = "instance_type must be one of: t3.micro, t3.small, t3.medium, t3.large."
  }
}

variable "sg_name" {
  description = "Name of the security group"
  type        = string
  default     = "ce-lab-sg"
}