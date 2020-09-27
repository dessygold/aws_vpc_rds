# Create VPC TESTSTACKVPC With CIDR Block 10.0.0.0/16
resource "aws_vpc" "stackvpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    tags {
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

    tags {
        Name = "NATSG"
    }
}

resource "aws_instance" "nat" {
    ami = "ami-30913f47" # this is a special ami preconfigured to do NAT
    availability_zone = "us-east-1b"
    instance_type = "m1.small"
    key_name = var.aws_key_name
    vpc_security_group_ids = ["${aws_security_group.nat.id}"]
    subnet_id = aws_subnet.stack-public-subnet.id
    associate_public_ip_address = true
    source_dest_check = false

    tags {
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
    availability_zone = "us-east-1a"

    tags {
        Name = "Public Subnet"
    }
}

# The route tables associated with our public subnet (including custom route tables)
# must have a route to the internet gateway.

resource "aws_route_table" "stack-rt-public" {
    vpc_id = aws_vpc.stackvpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.stackigw.id
    }

    tags {
        Name = "Public Subnet"
    }
}

resource "aws_route_table_association" "stack-rta-public" {
    subnet_id = aws_subnet.stack-public-subnet.id
    route_table_id = aws_route_table.stack-rt-public.id
}

/*
  Private Subnet,  Route table and rt Association and NAT association with RT
*/
resource "aws_subnet" "stack-private-subnet" {
    vpc_id = aws_vpc.stackvpc.id

    cidr_block = var.private_subnet_cidr
    availability_zone = "us-east-1b"

    tags {
        Name = "Private Subnet"
    }
}

resource "aws_route_table" "stack-rt-private" {
    vpc_id = aws_vpc.stackvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        instance_id = aws_instance.nat.id
    }

    tags {
        Name = "Private Subnet"
    }
}

resource "aws_route_table_association" "stack-rta-private" {
    subnet_id = aws_subnet.stack-private-subnet.id
    route_table_id = aws_route_table.stack-rt-private.id
}