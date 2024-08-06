terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.59.0"
    }
  }
}

# Configure the AWS provider
provider "aws" {
  region = "us-east-1"  # Change to your preferred region
}

# Define variables
variable "aws_region" {
  description = "The AWS region to deploy resources in."
  default     = "us-east-1"  # Change to your preferred region
}

variable "my_ip" {
  description = "Your IP address to allow SSH access."
  default     = "YOUR_IP_ADDRESS/32"  # Replace with your actual IP address
}

variable "key_name" {
  description = "The name of the key pair to use for SSH."
  default     = "client-key-pair"
}

# Define the security group for clients
resource "aws_security_group" "clients_sg" {
  name        = "client-SG"
  description = "Allow SSH access from specific IP and control-SG."

  # Allow SSH from specific IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  # Allow SSH from control-SG security group
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [
      aws_security_group.control_sg.id
    ]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "client-SG"
  }
}

# Data source to retrieve existing security group
data "aws_security_group" "control_sg" {
  filter {
    name   = "group-name"
    values = ["control-SG"]
  }
}

# Define the EC2 instances
resource "aws_instance" "web" {
  count         = 3
  ami           = "ami-0b6b2d9d92f8b8b8d"  # CentOS Stream 9 AMI ID for us-east-1; change as needed
  instance_type = "t2.micro"
  key_name      = var.key_name
  security_groups = [
    aws_security_group.clients_sg.name
  ]
  tags = {
    Name = "web00-${count.index + 1}"
  }

  # Optionally, you can provide a user data script to configure your instance
  user_data = <<-EOF
                #!/bin/bash
                echo date
              EOF
}

# Output the public IPs of the instances
output "instance_ips" {
  value = aws_instance.web[*].public_ip
}
