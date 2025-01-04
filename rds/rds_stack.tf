resource "aws_db_instance" "dpe_postgresdb" {
  identifier            = "dpe-postgres-db"
  allocated_storage     = 50
  max_allocated_storage = 100
  db_name               = "dpeDB"
  engine                = "postgres"
  engine_version        = "15.4"
  instance_class        = "db.t3.micro"
  username              = aws_ssm_parameter.rds_postgres_username.value
  password              = aws_ssm_parameter.rds_postgres_password.value
  publicly_accessible   = true
  # parameter_group_name    = "default.mysql8.0"
  skip_final_snapshot     = true
  backup_retention_period = 7
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet.name
  vpc_security_group_ids  = [aws_security_group.rds_allow_tls.id]

  tags = {
    Name  = "DPE RDS PostgresDB"
    Owner = "Data Platform Team"
  }

  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }
}