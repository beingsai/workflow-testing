provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "default" {
  default = true
}

# Use the correct subnet ID for ap-south-1a in your default VPC
data "aws_subnet" "controller_subnet" {
  id = "subnet-0e4c077a270a82185"
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.default.id
}

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

resource "aws_instance" "splunk_ec2" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnet.controller_subnet.id
  vpc_security_group_ids      = [data.aws_security_group.default.id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  tags = {
    Name = "SplunkInstance"
  }
}
