//----Web_Server----//
provider "aws" {
  region = var.country
  //N.California
}
data "aws_ami" "id_RedHat" {
  owners      = [
    "309956199498"]
  most_recent = true
  filter {
    name   = "name"
    values = ["RHEL-8.0.0_HVM-*-x86_64-1*"]
  }
  tags     = merge(var.com_tags, { Name = "Hard Disk for Server ${var.com_tags.Enviroment}" })
}

resource "aws_eip" "elastic_ip" {
  instance = aws_instance.Server.id
  tags     = merge(var.com_tags, { Name = "Public IP for Server ${var.com_tags.Enviroment}" })
}
resource "aws_instance" "Server" {
  ami                    = data.aws_ami.id_RedHat.id#Amazon linux AMI
  instance_type          = var.Type_server
  monitoring             = var.Detail_monitoring
  vpc_security_group_ids = [
    aws_security_group.Server.id]
  tags                   = merge(var.com_tags, { Name = "${var.com_tags.Enviroment} Server in AWS" })
}
resource "aws_security_group" "Server" {
  name        = "Security group for Web_2"
  description = "Test security of Terraform"
  dynamic "ingress" {
    for_each = var.port_for_server

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [
        "0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
     tags       = merge(var.com_tags, { Name = "Security Group for Server ${var.com_tags.Enviroment}"})
}
