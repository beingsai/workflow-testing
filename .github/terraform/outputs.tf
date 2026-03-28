output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.splunk_ec2.id
}

output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.splunk_ec2.public_ip
}

output "public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.splunk_ec2.public_dns
}
