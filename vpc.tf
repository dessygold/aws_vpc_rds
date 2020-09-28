# Create VPC TESTSTACKVPC With CIDR Block 10.0.0.0/16
resource "aws_vpc" "stackvpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true

    
tags = {
        Name = "TF-aws-vpc"
    }

}

# In order for the resources in a VPC to send and receive traffic from the internet
# An internet gateway must be attached to the VPC.

resource "aws_internet_gateway" "stackigw" {
    vpc_id = aws_vpc.stackvpc.id
}

/*
  NAT Instance
*/
resource "aws_security_group" "nat" {
    name = "vpc_nat"
    description = "Allow traffic to pass from the private subnet to the internet"
    vpc_id = aws_vpc.stackvpc.id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["${var.private_subnet_cidr}"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["${var.private_subnet_cidr}"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.vpc_cidr}"]
    }
    egress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "NATSG"
    }
}
# NAT Instance
resource "aws_instance" "nat" {
    ami = "ami-0ff8a91507f77f867" # this is a special ami preconfigured to do NAT
    availability_zone = "us-east-1d"
    instance_type = "m1.small"
    key_name = aws_key_pair.public-ec2-key.key_name
    vpc_security_group_ids = ["${aws_security_group.nat.id}"]
    subnet_id = aws_subnet.stack-public-subnet.id
    associate_public_ip_address = true
    source_dest_check = false

    tags = {
        Name = "VPC NAT"
    }
}

resource "aws_eip" "nat" {
    instance = aws_instance.nat.id
    vpc = true
}

/*
  Public Subnet 
*/
resource "aws_subnet" "stack-public-subnet" {
    vpc_id = aws_vpc.stackvpc.id

    cidr_block = var.public_subnet_cidr
    availability_zone = "us-east-1d"

    tags = {
        Name = "Public Subnet"
    }
}


/*
  Private Subnet
*/
resource "aws_subnet" "stack-private-subnet" {
    vpc_id = aws_vpc.stackvpc.id

    cidr_block = var.private_subnet_cidr
    availability_zone = "us-east-1c"

    tags = {
        Name = "Private Subnet"
    }
}