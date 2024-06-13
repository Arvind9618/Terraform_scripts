------
These are Basic Terraform scripts 
main.tf conatins script to create vpc, create 2 subnets, create 2 routetables and attach one with one subnet and igw and another with another subnet and attach it to private nat
provider.tf Defines provider configuration
----------------
null/null.tf defines null resource
----------------
ec2/main.tf conatins Provider details, create vpc, create 1 subnets, create 1 route table and attach one with one subnet and igw and Create a security group for EC2 instance, and create an EC2 instance with a AMI
-------
ec2/automation_of_creating_multiple_instances contains file which creates 5 vpc's and adds public subnet and routes to internet gateway for the vpc's. Moreover on each vpc a single instance with public Ip enabled, ami id, security group, and gives output of the public ip's.
-----
