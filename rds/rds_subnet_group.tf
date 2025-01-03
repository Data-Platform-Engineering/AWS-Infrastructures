resource "aws_db_subnet_group" "rds_subnet" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.rds-public-subnet.id, aws_subnet.rds-private-subnet.id]

  tags = {
    Name = "My RDS PostgresDB subnet group"
  }
}