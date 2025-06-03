# Use existing Route53 zone
data "aws_route53_zone" "main" {
  zone_id = "Z09690781145818SEK9G6"  # Using the zone ID from the existing zone
}

# Create A record for app subdomain
resource "aws_route53_record" "app" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "app.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [var.elastic_ip]
} 