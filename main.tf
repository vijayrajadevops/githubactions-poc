# ModMed.tf

# VPC
resource "aws_vpc" "ModMed" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "ModMed-vpc"
  }
}

# Subnet
resource "aws_subnet" "ModMed" {
  vpc_id                  = aws_vpc.ModMed.id
  cidr_block              = var.subnet_cidr_block1
  availability_zone       = "us-east-1a"  # Modify based on your region
  map_public_ip_on_launch = true
  tags = {
    Name = "ModMed-subnet"
  }
}


resource "aws_subnet" "ModMed2" {
  vpc_id                  = aws_vpc.ModMed.id
  cidr_block              = var.subnet_cidr_block2
  availability_zone       = "us-east-1b"  # Modify based on your region
  map_public_ip_on_launch = true
  tags = {
    Name = "ModMed-subnet"
  }
}


# Internet Gateway 
resource "aws_internet_gateway" "ModMed" {
  vpc_id = aws_vpc.ModMed.id
  tags = {
    Name = "ModMed-igw"
  }
}

# Route Table
resource "aws_route_table" "ModMed" {
  vpc_id = aws_vpc.ModMed.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ModMed.id
  }

  tags = {
    Name = "ModMed-route-table"
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "ModMed" {
  subnet_id      = aws_subnet.ModMed.id
  route_table_id = aws_route_table.ModMed.id
}

# Security Group for EC2 Instance
resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.ModMed.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-sg"
  }
}

# EC2 Instance
resource "aws_instance" "ModMed" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.ModMed.id
  associate_public_ip_address = true

  tags = {
    Name = "ModMed-ec2-instance"
  }
}

module "eks"{

source = "./modules/eks"
}