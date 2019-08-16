provider "aws" {
  region = "us-west-1"
}
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags       = {
	Name = "My VPC"
  }
}