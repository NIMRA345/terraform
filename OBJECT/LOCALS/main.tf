provider "aws" {
  region = local.region
}

locals {
  # General configuration
  region   = "us-east-1"
  key_name = "my-ec2-key"

  # Single object containing all EC2 instance configs
  instances = {
    Apache1 = {
      name          = "Apache-1"
      instance_type = "t2.medium"
      ami           = "ami-0b5eea76982371e91"
    }
    Apache2 = {
      name          = "Apache-2"
      instance_type = "t2.small"
      ami           = "ami-0b5eea76982371e91"
    }
    Apache3 = {
      name          = "Apache-3"
      instance_type = "t2.micro"
      ami           = "ami-0b5eea76982371e91"
    }
  }

  # Security group
  sg_name     = "apache_sg"
  cidr_blocks = ["0.0.0.0/0"]
  ssh_port    = 22
  http_port   = 80

  # Egress rule
  egress_port     = 0
  egress_protocol = "-1"
}

# Security group
resource "aws_security_group" "apache_sg" {
  name        = local.sg_name
  description = "Allow SSH and HTTP"

  ingress {
    description = "SSH"
    from_port   = local.ssh_port
    to_port     = local.ssh_port
    protocol    = "tcp"
    cidr_blocks = local.cidr_blocks
  }

  ingress {
    description = "HTTP"
    from_port   = local.http_port
    to_port     = local.http_port
    protocol    = "tcp"
    cidr_blocks = local.cidr_blocks
  }

  egress {
    from_port   = local.egress_port
    to_port     = local.egress_port
    protocol    = local.egress_protocol
    cidr_blocks = local.cidr_blocks
  }

  tags = {
    Name = local.sg_name
  }
}

# EC2 instances using for_each on single object
resource "aws_instance" "apache_server" {
  for_each        = local.instances
  ami             = each.value.ami
  instance_type   = each.value.instance_type
  key_name        = local.key_name
  security_groups = [aws_security_group.apache_sg.name]

  tags = {
    Name = each.value.name
  }
}

# Output public IPs
output "ec2_public_ip" {
  value       = { for k, inst in aws_instance.apache_server : inst.tags["Name"] => inst.public_ip }
  description = "Public IP of Apache servers"
}
