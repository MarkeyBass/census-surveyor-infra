output "zone_id" {
  description = "The ID of the Route53 zone"
  value       = data.aws_route53_zone.main.zone_id
}

output "name_servers" {
  description = "The nameservers of the Route53 zone"
  value       = data.aws_route53_zone.main.name_servers
}

output "certificate_arn" {
  description = "ARN of the ACM certificate"
  value       = aws_acm_certificate_validation.app_certificate_validation.certificate_arn
} 