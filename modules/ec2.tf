# # Create two EC2 Instance, one in public and other in Private subnet
# resource "aws_instance" "${var.goldprefix}" {
#   ami                    = var.ami
#   instance_type          = var.instance_type
#   iam_instance_profile   = var.iam_instance_profile
#   key_name               = var.ec2_key_name
#   user_data              = var.user_data
#   network_interface {
#     network_interface_id = aws_network_interface.my_network_interface_public.id
#     device_index         = 0
#   }

#   credit_specification {
#     cpu_credits = "unlimited"
#   }
# }
# resource "aws_network_interface" "my_network_interface_public" {
#   subnet_id       = aws_subnet.stack-public-subnet.id
#   private_ips     = ["10.0.0.7"]
#   security_groups = [aws_security_group.public-instance.id] 

#   tags = {
#     Name = "VPC-PUBLIC"
#   }
# }


# resource "aws_eip" "ec2_pip" {
#   vpc = true

#   network_interface         = aws_network_interface.my_network_interface_public.id
#   associate_with_private_ip = aws_instance.stack-ec2-public.private_ip
#   depends_on                = [aws_internet_gateway.stackigw] 
# }


# # Create two EC2 Instance, one in public and other in Private subnet
# resource "aws_instance" "stack-ec2-public" {
#   ami                    = "ami-0c94855ba95c71c99"
#   instance_type          = "t2.micro"
#   iam_instance_profile   = aws_iam_instance_profile.test_profile.name
#   key_name               = aws_key_pair.public-ec2-key.key_name
#   user_data              = file("server-script.sh")
#   network_interface {
#     network_interface_id = aws_network_interface.my_network_interface_public.id
#     device_index         = 0
#   }

#   credit_specification {
#     cpu_credits = "unlimited"
#   }
# }
# resource "aws_network_interface" "my_network_interface_public" {
#   subnet_id       = aws_subnet.stack-public-subnet.id
#   private_ips     = ["10.0.0.7"]
#   security_groups = [aws_security_group.public-instance.id] 

#   tags = {
#     Name = "VPC-PUBLIC"
#   }
# }


# resource "aws_eip" "ec2_pip" {
#   vpc = true

#   network_interface         = aws_network_interface.my_network_interface_public.id
#   associate_with_private_ip = aws_instance.stack-ec2-public.private_ip
#   depends_on                = [aws_internet_gateway.stackigw] 
# }
