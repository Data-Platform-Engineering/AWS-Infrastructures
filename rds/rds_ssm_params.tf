resource "aws_ssm_parameter" "rds_postgres_username" {
  name  = "/dpe/rds_postgres/username"
  type  = "String"
  value = "dpeadmin"
}

resource "random_password" "rds_postgres_password" {
  length  = 24
  special = false
}

resource "aws_ssm_parameter" "rds_postgres_password" {
  name  = "/dpe/rds_postgres/password"
  type  = "String"
  value = random_password.rds_postgres_password.result
}