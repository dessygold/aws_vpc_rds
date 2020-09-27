# Create two EC2 Instance, one in public and other in Private subnet
resource "aws_instance" "stack-ec2-public" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ec2_key.key_name
  user_data     = file("server-script.sh")
  network_interface {
    network_interface_id = aws_network_interface.my_network_interface.id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
}
resource "aws_network_interface" "my_network_interface" {
  subnet_id       = aws_subnet.stack-public-subnet.id
  private_ips     = ["10.0.0.7"]
  security_groups = [aws_security_group.nat.id] 

  tags = {
    Name = "STACK-EC2-PUBLIC"
  }
}


resource "aws_eip" "ec2_pip" {
  vpc = true

  network_interface         = aws_network_interface.my_network_interface.id
  associate_with_private_ip = aws_instance.stack-ec2-public.private_ip
  depends_on                = [aws_internet_gateway.stackigw] 
}

# EC2 For Private Subnet, this EC2 will require NAT to access the internet

resource "aws_instance" "stack-ec2-private" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ec2_key.key_name
  user_data     = file("server-script2.sh")
  network_interface {
    network_interface_id = aws_network_interface.my_network_interface.id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
}
resource "aws_network_interface" "my_network_interface" {
  subnet_id       = aws_subnet.stack-private-subnet.id
  private_ips     = ["10.0.1.8"]
  security_groups = [aws_security_group.nat.id] 

  tags = {
    Name = "STACK-EC2-PUBLIC"
  }
}


# resource "aws_eip" "ec2_pip" {
#   vpc = true

#   network_interface         = aws_network_interface.my_network_interface.id
#   associate_with_private_ip = aws_instance.stack-ec2-public.private_ip
#   depends_on                = [aws_internet_gateway.stackigw] 
# }



# "~/.ssh/id_rsa/id_pub.pub"
#https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#how-to-generate-your-own-key-and-import-it-to-aws
#https://docs.aws.amazon.com/vpc/latest/userguide/vpc-dns.html
#ssh-keygen -m PEM
resource "aws_key_pair" "ec2_key" {
  key_name   = "ec2-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDuxJ/zNqwkxMk4pjDFU4Hp6z+eaIIgZXTxGdD4NclBa5WQdggxTS5/3o3H+IOpkvKSAEXnAfwsd7S4dlMSN5DbAbEMG9g5zyjNrH27IcHv2TRXtbNkGro2/paE0xaPTcoGpfcTE5Tv0vBM5vGiaXSXXgizR3UJwBu0Kt6qm7tEjvvefyWNgC7jqh3NZ2xt7lpqJUWw46x0yU94FnorkqXIN2jb5Q9hwGAGT9+/vU01VPdT7bzpNtJ+2pNaHvmVdX1FmJYbghUtC8wkm/rtnpaZgGzvcibm/797gLUZfdNuWpWvKBEOByo12MXX4hlj4i30QnhtQnt9zGS3pUu32YiawcKVOAeCFnsXfSUlJCLpQ3nelX7J8F7ok08Z3gTHGFtTKKJDPx/T7dTpKY/JPI25hmm2ME6mJMZ5QvneWvicijnAlFNmTxKkj0QiKvspFjtaljpcpov/x00OrRHhnNh8XaqD9P+yV5wprjNpBPoYnjCDgnLWx9lG1lGUs/fHW70= dessy@DESSYGOLD-PC"
}


#--------------
# hosted zones 
#--------------

# resource "aws_route53_zone" "dessygold" {
#   name = "dessygold.com"
#   tags = {
#       env = "development"
#   }
# }

# resource "aws_route53_record" "dessygold_a_eip" {
#   zone_id = aws_route53_zone.dessygold.zone_id
#   name    = "dessygold.com"
#   type    = "A"
#   ttl     = "30"
#   records = [aws_eip.ec2_pip.public_ip]
# }


#tls 
#https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/SSL-on-amazon-linux-2.html

#lamp server 

#https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html
#https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html
#https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#how-to-generate-your-own-key-and-import-it-to-aws

#ssh -i ~/.ssh/ec2-key-pair ec2-user@3.82.182.17

