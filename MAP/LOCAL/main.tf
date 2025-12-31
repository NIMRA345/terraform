provider "aws" {
  region = local.region
}

locals {
  # General configuration
  region        = "us-east-1"
  ami_id        = "ami-0b5eea76982371e91"
  key_name      = "my-ec2-key"

  # MAP of instance names and types
  instance_names = {
    "Apache-1" = "t2.medium"
    "Apache-2" = "t2.small"
    "Apache-3" = "t2.micro"
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

# EC2 instances using for_each with map of names and types
resource "aws_instance" "apache_server" {
  for_each        = local.instance_names
  ami             = local.ami_id
  instance_type   = each.value   # Each instance gets its type from the map value
  key_name        = local.key_name
  security_groups = [aws_security_group.apache_sg.name]

  tags = {
    Name = each.key  # Instance name comes from the map key
  }
}

# Output public IPs
output "ec2_public_ip" {
  value       = { for name, inst in aws_instance.apache_server : name => inst.public_ip }
  description = "Public IP of Apache servers"
}
provider "aws" {
  region = local.region
}

locals {
  # General configuration
  region        = "us-east-1"
  ami_id        = "ami-0b5eea76982371e91"
  key_name      = "my-ec2-key"

  # MAP of instance names and types
  instance_names = {
    "Apache-1" = "t2.medium"
    "Apache-2" = "t2.small"
    "Apache-3" = "t2.micro"
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

# EC2 instances using for_each with map of names and types
resource "aws_instance" "apache_server" {
  for_each        = local.instance_names
  ami             = local.ami_id
  instance_type   = each.value   # Each instance gets its type from the map value
  key_name        = local.key_name
  security_groups = [aws_security_group.apache_sg.name]

  tags = {
    Name = each.key  # Instance name comes from the map key
  }
}

# Output public IPs
output "ec2_public_ip" {
  value       = { for name, inst in aws_instance.apache_server : name => inst.public_ip }
  description = "Public IP of Apache servers"
}
