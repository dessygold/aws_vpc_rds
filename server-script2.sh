#!/bin/bash
sudo yum update
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
echo "<h1>Hello from Desmond, This is My EC2 ( PRIVATE SUB EC2) Welcome to Terraform VPC LAB1, Please Submit your Objective Evidence!!!</h1>" | sudo tee /var/www/html/index.html