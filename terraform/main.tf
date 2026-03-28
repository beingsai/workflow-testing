# Existing code (VPC, subnet, AMI, etc.)

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
