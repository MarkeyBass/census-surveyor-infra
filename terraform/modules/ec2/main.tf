data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "${var.environment}-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.small"
  subnet_id     = var.subnet_id
  key_name      = aws_key_pair.generated_key.key_name

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
              apt-get install -y docker-compose-plugin
              ln -s /usr/libexec/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose
              
              # Verify installations
              docker --version
              docker-compose --version
              EOF

  tags = {
    Name        = "${var.environment}-app-server"
    Environment = var.environment
  }
}

resource "aws_eip" "app_eip" {
  instance = aws_instance.app_server.id
  domain   = "vpc"

  tags = {
    Name        = "${var.environment}-app-eip"
    Environment = var.environment
  }
} 