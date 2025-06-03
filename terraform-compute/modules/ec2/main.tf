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

  vpc_security_group_ids = [var.security_group_id]

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

resource "aws_security_group" "ec2_sg" {
  name        = "${var.environment}-ec2-app-sg"
  description = "Security group for EC2 instance running Docker applications"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS access"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Client application"
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Server application"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name        = "${var.environment}-ec2-app-sg"
      Environment = var.environment
      Purpose     = "Docker applications"
    },
    var.tags
  )
}

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