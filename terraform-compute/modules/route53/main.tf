# Use existing Route53 zone
data "aws_route53_zone" "main" {
  zone_id = "Z09690781145818SEK9G6"  # Using the zone ID from the existing zone
}

# Create A record for app subdomain pointing to ALB
resource "aws_route53_record" "app" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "app.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

# Create SSL certificate for the domain
resource "aws_acm_certificate" "app_certificate" {
  domain_name       = "app.${var.domain_name}"
  validation_method = "DNS"
  subject_alternative_names = ["*.app.${var.domain_name}"]

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Environment = var.environment
  }
}

# Create DNS record for certificate validation
resource "aws_route53_record" "certificate_validation" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.app_certificate.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.app_certificate.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.app_certificate.domain_validation_options)[0].resource_record_type
  zone_id         = data.aws_route53_zone.main.zone_id
  ttl             = 60
}

# Validate the certificate
resource "aws_acm_certificate_validation" "app_certificate_validation" {
  certificate_arn         = aws_acm_certificate.app_certificate.arn
  validation_record_fqdns = [aws_route53_record.certificate_validation.fqdn]
} 