output "bucket_id" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.app_bucket.id
}

output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.app_bucket.arn
}

output "bucket_domain_name" {
  description = "The bucket domain name"
  value       = aws_s3_bucket.app_bucket.bucket_domain_name
} 