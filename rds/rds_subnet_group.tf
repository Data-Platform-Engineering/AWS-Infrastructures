resource "aws_db_subnet_group" "rds_subnet" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.rds_public_subnet_1.id, aws_subnet.rds_public_subnet_2.id]

  tags = {
    Name = "My RDS PostgresDB subnet group"
  }
}