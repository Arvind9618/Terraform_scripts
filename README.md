Terraform Infrastructure Deployment
------
Overview
----------
This Terraform configuration consists of several scripts and modules designed to automate the provisioning of various AWS resources, including Virtual Private Clouds (VPCs), subnets, route tables, security groups, and EC2 instances.

Structure and Components
Main Configuration (main.tf):
------------------
VPC Creation: Defines and provisions a VPC.
Subnets Creation: Creates two subnets within the VPC.
Route Tables: Establishes two route tables and associates each with a subnet. One route table is attached to an Internet Gateway (IGW), while the other is associated with a private NAT.

Provider Configuration (provider.tf):
-------------
Configures the necessary provider details for Terraform to interact with AWS services.

Null Resource (null/null.tf):
--------------
Defines a null resource which can be used for various auxiliary tasks such as triggering provisioners and running external scripts.

EC2 Instance Configuration (ec2/main.tf):
-----------
**Provider Details**: Specifies the provider configuration for AWS.
**VPC and Subnet**: Creates a VPC and a single subnet within it.
**Route Table**: Establishes a route table and attaches it to the subnet and IGW.
**Security Group**: Creates a security group to control the ingress and egress traffic for the EC2 instance.
**EC2 Instance**: Provisions an EC2 instance using a specified AMI, associating it with the created subnet and security group.

Automated Multiple VPC and Instance Creation (ec2/automation_of_creating_multiple_instances):
------------
**Multiple VPCs**: Automates the creation of five VPCs.
**Public Subnets and Routes**: Adds public subnets and configures routes to the Internet Gateway for each VPC.
**EC2 Instances**: For each VPC, provisions an EC2 instance with a public IP, specific AMI ID, and security group.
**Output**: Provides the public IP addresses of the EC2 instances as output.
