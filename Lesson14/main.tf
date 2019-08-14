provider "aws" {
  region = "us-west-1"
}
####Create and save password in SystemManager Parametr Store
variable "name" {
  default = "Maks"
}
resource "random_string" "pass" {
  length           = 12
  special          = true
  override_special = "!#$&"
  keepers          = {
	name1 = var.name
  }
}
resource "aws_ssm_parameter" "pass" {
  name        = "/prod/mysql"
  description = "Master Password for MySQL"
  type        = "SecureString"
  value       = random_string.pass.result
}
data "aws_ssm_parameter" "rds_pass" {
  name       = "/prod/mysql"
  depends_on = [
	aws_ssm_parameter.pass]
}
######Create a RDS Database and take in password for DB
resource "aws_db_instance" "db_pass_instance" {
  identifier           = "development-db"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "DB"
  username             = "dereban"
  password             = data.aws_ssm_parameter.rds_pass.value
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  apply_immediately    = true
  publicly_accessible  = true
}
