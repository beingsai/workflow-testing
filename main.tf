########################################
# Terraform Configuration
########################################

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

########################################
# AWS Provider
########################################

provider "aws" {
  region = var.aws_region
}

########################################
# Variables (With Defaults)
########################################

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Existing EC2 key pair name"
  type        = string
  default     = "my-keypair" # CHANGE if needed
}

########################################
# Data Sources
########################################

# Get all available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Get default subnet from first AZ
data "aws_subnet" "default" {
  default_for_az    = true
  availability_zone = data.aws_availability_zones.available.names[0]
}

# Get default security group
data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.default.id
}

# Get latest Amazon Linux 2023 AMI
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

########################################
# EC2 Instance
########################################

resource "aws_instance" "splunk_ec2" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnet.default.id
  vpc_security_group_ids       = [data.aws_security_group.default.id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  tags = {
    Name        = "SplunkInstance"
    Environment = "github-actions"
  }
}

########################################
# Outputs
########################################

output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.splunk_ec2.id
}

output "public_ip" {
  description = "EC2 Public IP"
  value       = aws_instance.splunk_ec2.public_ip
}
