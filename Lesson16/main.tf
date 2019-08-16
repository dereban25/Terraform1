#-----------------------
#
#Terraform Count and For if
#Owner Derbenev Maksym
#-----------------------
provider "aws" {
  region = "us-west-1"
}
resource "aws_iam_user" "create_user" {
  count = length(var.aws_users)
  name  = var.aws_users[count.index]
}
resource "aws_instance" "bastion_server" {
  count         = 2
  ami           = "ami-08fd8ae3806f09a08"
  instance_type = "t2.micro"
  tags          = {
	Name = "Bastion Server ${count.index + 1}"
  }
}
