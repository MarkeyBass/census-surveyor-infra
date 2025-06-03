data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = [var.ami_owner]

  filter {
    name   = "name"
    values = [var.ami_name_pattern]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "tls_private_key" "ssh_key" {
  count     = var.ssh_key_name == null ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  count      = var.ssh_key_name == null ? 1 : 0
  key_name   = "${var.environment}-key"
  public_key = tls_private_key.ssh_key[0].public_key_openssh
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.ssh_key_name != null ? var.ssh_key_name : aws_key_pair.generated_key[0].key_name

  vpc_security_group_ids = [var.vpc_security_group_id]

  user_data = <<-EOF
              #!/bin/bash
              # Update system
              apt-get update
              
              # Install Docker
              apt-get install -y docker.io
              systemctl start docker
              systemctl enable docker
              usermod -aG docker ubuntu
              
              # Install Docker Compose
              apt-get install -y docker-compose
              
              # Verify installations
              docker --version
              docker-compose --version
              EOF

  # Force recreation when user_data changes
  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    {
      Name        = "${var.environment}-app-server"
      Environment = var.environment
    },
    var.tags
  )
}

# Get current AWS region
data "aws_region" "current" {}

resource "aws_eip" "app_eip" {
  depends_on = [
    aws_instance.app_server
  ]
  
  instance = aws_instance.app_server.id
  domain   = "vpc"

  tags = merge(
    {
      Name        = "${var.environment}-app-eip"
      Environment = var.environment
    },
    var.tags
  )
}