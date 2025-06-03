# Route 53 Hosted Zone
resource "aws_route53_zone" "main" {
  name = var.domain_name

  tags = merge(
    {
      Name        = "${var.environment}-route53-zone"
      Environment = var.environment
    },
    var.tags
  )
}

# DNS A Record for the app subdomain
resource "aws_route53_record" "app" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "app.${var.domain_name}"
  type    = "A"
  ttl     = "300"
  records = [var.elastic_ip]
} 