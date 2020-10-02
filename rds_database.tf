resource "aws_db_instance" "stack-rds-db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0.20"
  instance_class       = "db.t2.micro"
  name                 = var.rdsdb_name
  username             = var.rds_username
  password             = var.rds_password
  parameter_group_name = "default.mysql8.0"

  db_subnet_group_name = aws_db_subnet_group.rds-subgroup.name
  vpc_security_group_ids = [aws_security_group.private-instance.id]

  max_allocated_storage = "1000"

  skip_final_snapshot = true

  tags = {
    Name = "rds-db"
  }



}




resource "aws_db_subnet_group" "rds-subgroup" {
  name = "rds-subnet-group"
  subnet_ids = [
    aws_subnet.rds-private-subnet.id,
    aws_subnet.stack-private-subnet.id
    ]
}