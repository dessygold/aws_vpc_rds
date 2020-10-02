# The route tables associated with our public subnet (including custom route tables)
# must have a route to the internet gateway.

resource "aws_route_table" "stack-rt-public" {
    vpc_id = aws_vpc.stackvpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.stackigw.id
    }

    tags = {
        Name = "Public Subnet"
    }
}

resource "aws_route_table_association" "stack-rta-public" {
    subnet_id = aws_subnet.stack-public-subnet.id
    route_table_id = aws_route_table.stack-rt-public.id
}

# The route tables associated with our private subnet , its locked down and no igw association. route to the NAT to have access to www.
resource "aws_route_table" "stack-rt-private" {
    vpc_id = aws_vpc.stackvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat-gateway.id
    }

    tags = {
        Name = "Private Subnet"
    }
}

resource "aws_route_table_association" "stack-rta-private" {
    subnet_id = aws_subnet.stack-private-subnet.id
    route_table_id = aws_route_table.stack-rt-private.id
}