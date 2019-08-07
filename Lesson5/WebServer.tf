//----Web_Server----//
provider "aws" {
  region = "us-west-1" //N.California
}

resource "aws_eip" "elastic_ip" {
  instance = aws_instance.Web_Server.id
}
resource "aws_instance" "Web_Server" {
  ami                    = "ami-00fc224d9834053d6" #Amazon linux AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.Security_Web_Server.id]
  user_data = templatefile("user_data.sh.tpl", {
    f_name = "Maksym",
    l_name = "Derbenev",
    names  = ["Vasya", "Kolya", "Masha", "Donald", "John", "Test", "Maks", "XEEEE"]
  })
  tags = {
    Name = "Terraform_test"
  }
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_security_group" "Security_Web_Server" {
  name        = "Security group for Web_2"
  description = "Test security of Terraform"
  dynamic "ingress" {
    for_each = ["80", "443", "8080"]

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
