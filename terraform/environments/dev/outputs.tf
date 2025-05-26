# AWS Account Information
output "aws_account_id" {
  description = "The AWS Account ID being used"
  value       = data.aws_caller_identity.current.account_id
}

output "aws_arn" {
  description = "The ARN of the AWS identity being used"
  value       = data.aws_caller_identity.current.arn
}

output "aws_user_id" {
  description = "The unique identifier of the AWS account"
  value       = data.aws_caller_identity.current.user_id
}

# S3 Bucket Information
output "s3_bucket" {
  description = "All S3 bucket information"
  value = {
    id             = module.s3.bucket_id
    arn            = module.s3.bucket_arn
    domain_name    = module.s3.bucket_domain_name
  }
}

output "ec2_elastic_ip" {
  description = "The Elastic IP address of the EC2 instance"
  value       = module.ec2.elastic_ip
}

output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = module.ec2.instance_id
}

output "ec2_private_key" {
  description = "The private SSH key for connecting to the EC2 instance"
  value       = module.ec2.private_key
  sensitive   = true
} 