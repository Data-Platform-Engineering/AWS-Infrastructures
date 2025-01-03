resource "aws_ssm_parameter" "rds_postgres_username" {
  name  = "/dpe/rds_postgres/username"
  type  = "String"
  value = "dpeadmin"
}

resource "aws_ssm_parameter" "rds_postgres_password" {
  name  = "/dpe/rds_postgres/password"
  type  = "String"
  value = "Password123"
}