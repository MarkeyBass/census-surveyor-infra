output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.app_server.id
}

output "elastic_ip" {
  description = "The Elastic IP address associated with the EC2 instance"
  value       = aws_eip.app_eip.public_ip
}

output "private_key" {
  description = "The private SSH key for the EC2 instance (only if a new key was generated)"
  value       = var.ssh_key_name == null ? tls_private_key.ssh_key[0].private_key_pem : null
  sensitive   = true
} 