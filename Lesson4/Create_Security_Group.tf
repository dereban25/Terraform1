//----Web_Server----//
provider "aws" {
  region = "us-west-1" //N.California
}


resource "aws_security_group" "Web_Server" {
  name = "Dymanic Security group"

  dynamic "ingress" {
    for_each = ["80", "443", "8080", "43", "21", "143"]

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.10.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
