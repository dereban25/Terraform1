#-----------------------
#
#Terraform Conditions and Lookups
#Owner Derbenev Maksym
#-----------------------
provider "aws" {
  region = "us-west-1"
}
/*resource "aws_instance" "webserver1" {
  ami           = "ami-08fd8ae3806f09a08"
  //instance_type = (var.env == "prod" ? "t2.large":"t2.micro")
  instance_type = var.env == "prod" ? var.ec2_size[ "prod" ] : var.ec2_size[ "dev" ]
  tags          = {
	Name  = "${var.env} - server"
	Owner = var.env == "prod" ? var.prod_owner:var.noprod_owner
  }
}*/
resource "aws_instance" "webserver2" {
  ami           = "ami-08fd8ae3806f09a08"
  instance_type = lookup(var.ec2_size, var.env)
  vpc_security_group_ids = [aws_security_group.Web_Server.id]
  tags          = {
	Name  = "${var.env} - server"
	Owner = var.env == "prod" ? var.prod_owner:var.noprod_owner
  }
}
resource "aws_instance" "bastion_server" {
  count         = var.env == "dev" ? 1 : 0
  ami           = "ami-08fd8ae3806f09a08"
  instance_type = "t2.micro"
  tags          = {
	Name = "Bastion Server for Dev-server"
  }
}
resource "aws_security_group" "Web_Server" {
  name = "Dymanic Security group"
  
  dynamic "ingress" {
	for_each = lookup(var.allow_ports, var.env)
	
	content {
	  from_port   = ingress.value
	  to_port     = ingress.value
	  protocol    = "tcp"
	  cidr_blocks = [ "0.0.0.0/0" ]
	}
  }
  egress {
	from_port   = 0
	to_port     = 0
	protocol    = "-1"
	cidr_blocks = [ "0.0.0.0/0" ]
  }
  
}