# Required Variables
variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet where the EC2 instance will be launched"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the EC2 instance will be launched"
  type        = string
}

variable "security_group_id" {
  description = "ID of the security group for the EC2 instance"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "ID of the ALB security group"
  type        = string
}

# Optional Variables with Defaults
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "ami_owner" {
  description = "Owner of the AMI to use"
  type        = string
  default     = "099720109477" # Canonical
}

variable "ami_name_pattern" {
  description = "Pattern to match AMI name"
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
}

variable "ssh_key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = null # If null, a new key will be generated
}

variable "tags" {
  description = "Additional tags for the EC2 instance"
  type        = map(string)
  default     = {}
} 