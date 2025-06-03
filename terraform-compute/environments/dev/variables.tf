# Provider Configuration
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-west-2"
}

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}

# Environment Configuration
variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "ssh_key_name" {
  description = "Name of the SSH key pair (if null, a new key will be generated)"
  type        = string
  default     = null
}

variable "domain_name" {
  description = "The domain name for Route53 zone"
  type        = string
  default     = "markeybass.net"
}

# Global Tags
variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {
    Project     = "census-surveyor"
    ManagedBy   = "terraform"
  }
} 