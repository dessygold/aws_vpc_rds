# Key pair for EC2 Instance in The Private Subnet ( key-priv.pub) run comand "ssh-keygen -t rsa" and select path to save key to
resource "aws_key_pair" "private-ec2-key" {
  key_name   = "private-key"
  public_key = file("key-priv.pub")
}
# Key pair for EC2 Instance in The Public Subnet ( key2-public.pub)
resource "aws_key_pair" "public-ec2-key" {
  key_name   = "public-key"
  public_key = file("key2-public.pub")
}