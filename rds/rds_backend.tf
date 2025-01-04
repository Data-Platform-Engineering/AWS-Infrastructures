terraform {
  backend "s3" {
    bucket = "generic-terraform-state-files"
    key    = "production-rds"
    region = "eu-central-1"
  }
}