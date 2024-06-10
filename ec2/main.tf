/* Define Provider details, create vpc, create 1 subnets, create 1 routetable and
attach one with one subnet and igw and Create a security group for EC2 instance, 
and create an EC2 instance with a AMI */
provider "aws" {
  region = "us-east-2" # Northern Virginia region
  access_key = "*******"
  secret_key = "*******"
}
# VPC creation
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "my-vpc"
  }
}

# Subnet creation
resource "aws_subnet" "main_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "my-subnet"
  }
}

# Internet Gateway creation
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "my-igw"
  }
}

# Associate the subnet with the route table
resource "aws_route_table_association" "main_subnet_association" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_vpc.main.main_route_table_id
}

# Create a security group for EC2 instance
resource "aws_security_group" "instance_sg" {
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "instance-sg"
  }
}

# EC2 instance creation
resource "aws_instance" "i1" {
  ami           = "ami-0c7217cdde317cfec" 
  instance_type = "t2.micro"

  subnet_id = aws_subnet.main_subnet.id

  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  tags = {
    Name = "i1"
  }
}
