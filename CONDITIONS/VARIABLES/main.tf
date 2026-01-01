provider "aws" {
  region = var.region
}

resource "aws_security_group" "apache_sg" {
  name        = var.sg_name
  description = "Allow SSH and HTTP"

  ingress {
    description = "SSH"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }

  ingress {
    description = "HTTP"
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }

  # Single static egress rule
  egress {
    from_port   = var.egress_port
    to_port     = var.egress_port
    protocol    = var.egress_protocol
    cidr_blocks = var.cidr_blocks
  }

  tags = {
    Name = var.sg_name
  }
}

resource "aws_instance" "apache_server" {
  for_each = { for name, inst in var.instances : name => inst if inst.enabled }

  ami           = each.value.ami
  instance_type = each.value.type
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.apache_sg.id]

  tags = {
    Name = each.key
  }
}


output "ec2_public_ip" {
  value       = { for name, instance in aws_instance.apache_server : name => instance.public_ip }
  description = "Public IPs of Apache servers"
}
