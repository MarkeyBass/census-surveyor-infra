variable "environment" {
  description = "Environment name"
  type        = string
}

variable "domain_name" {
  description = "The domain name for the Route53 zone"
  type        = string
}

variable "elastic_ip" {
  description = "The Elastic IP address to use for DNS records"
  type        = string
}

variable "tags" {
  description = "Additional tags for Route53 resources"
  type        = map(string)
  default     = {}
} 