terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Security Group - Allow HTTP and app port
resource "aws_security_group" "dinner_decider_sg" {
  name        = "dinner-decider-sg"
  description = "Security group for Dinner Decider Flask app"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dinner-decider-sg"
  }
}

# Fetch latest Ubuntu 22.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 Instance
resource "aws_instance" "dinner_decider" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.dinner_decider_sg.id]
  associate_public_ip_address = true
  key_name = var.ssh_key_name

  user_data = base64encode(templatefile("${path.module}/user-data.sh.tpl", {
    repo_url      = var.github_repo_url
    gemini_key    = var.gemini_api_key
    unsplash_key  = var.unsplash_access_key
  }))

  tags = {
    Name = "dinner-decider-app"
  }

  depends_on = [aws_security_group.dinner_decider_sg]
}

data "aws_eip" "existing" {
  public_ip = "52.20.62.176"
}

resource "aws_eip_association" "use_existing" {
  instance_id   = aws_instance.dinner_decider.id
  allocation_id = data.aws_eip.existing.id
}