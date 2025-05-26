output "elastic_ip" {
  description = "The Elastic IP address of the EC2 instance"
  value       = aws_eip.app_eip.public_ip
}

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.app_server.id
}

output "private_key" {
  description = "The private SSH key for connecting to the EC2 instance"
  value       = tls_private_key.ssh_key.private_key_pem
  sensitive   = true
} 