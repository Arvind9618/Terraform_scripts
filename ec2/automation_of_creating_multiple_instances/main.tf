
# Define variables
variable "ami_id" {
  description = "AMI ID of the image you want to use for EC2 instance"
  default = "ami-0be8c419fc41b46b0"
}

variable "region" {
  description = "Region where the resources will be provisioned"
  default = "ap-south-2"  # Hyderabad region
}

# Create VPCs with public subnets and attach internet gateway
resource "aws_vpc" "vpc1" {
  count = 5
  cidr_block = "10.${count.index}.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC-${count.index + 1}"
  }
}

resource "aws_subnet" "sn1" {
  count = 5
  vpc_id = aws_vpc.vpc1[count.index].id
  cidr_block = "10.${count.index}.0.0/24"
  availability_zone = "${var.region}a"
  map_public_ip_on_launch = true  # Enable public IPs for instances in this subnet

  tags = {
    Name = "Subnet-${count.index + 1}"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  count = 5
  vpc_id = aws_vpc.vpc1[count.index].id
}

# Create a security group allowing RDP access from anywhere in each VPC
resource "aws_security_group" "sg1" {
  count = 5
  name        = "sg1-${count.index}"
  description = "Allow RDP access from anywhere"

  vpc_id      = aws_vpc.vpc1[count.index].id  # Associate with the VPC created above
  
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EC2 instances in each VPC's public subnet
resource "aws_instance" "M1" {
  count = 5

  ami           = var.ami_id  # Use the specified AMI
  instance_type = "m5d.large"  # Use the specified instance type

  subnet_id               = aws_subnet.sn1[count.index].id  # Attach to the public subnet within each VPC
  associate_public_ip_address = true  # Enable public IP address
  key_name                = ""  # No key required
  security_groups         = [aws_security_group.sg1[count.index].id]  # Attach the RDP access security group for the corresponding VPC

  tags = {
    Name = "Instance-${count.index + 1}"  # Unique name for each instance
  }
}

# Update route table to route traffic to internet gateway
resource "aws_route" "route_to_igw" {
  count          = 5
  route_table_id = aws_vpc.vpc1[count.index].main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw[count.index].id
}

# Output public IP addresses for each instance
output "public_ip_addresses" {
  value = { for idx, instance in aws_instance.M1 : idx => instance.public_ip }  
}
