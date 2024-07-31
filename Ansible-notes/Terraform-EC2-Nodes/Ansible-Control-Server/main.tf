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
  default     = "132.251.244.90/32"  # Replace with your actual IP address
}

variable "key_name" {
  description = "The name of the key pair to use for SSH."
  default     = "control-key-pair"
}

# Define the security group
resource "aws_security_group" "control_sg" {
  name        = "control-SG"
  description = "Allow SSH access from specific IP address."

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "control-SG"
  }
}

# Define the EC2 instance
resource "aws_instance" "control" {
  ami           = "ami-0a0e5d9c7acc336f1"  # Ubuntu 22.04 LTS AMI ID for us-east-1; change as needed
  instance_type = "t2.micro"
  key_name      = var.key_name
  security_groups = [
    aws_security_group.control_sg.name
  ]
  tags = {
    Name = "control"
  }
}

# Output the instance public IP
output "instance_ip" {
  value = aws_instance.control.public_ip
}
