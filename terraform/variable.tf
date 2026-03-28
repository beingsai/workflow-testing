variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"   # ✅ FIXED (free tier supported)
}

variable "key_name" {
  description = "EC2 Key Pair name"
  type        = string
  default     = "saiawsdem0-account-keypair"   # ❌ no .pem
}
