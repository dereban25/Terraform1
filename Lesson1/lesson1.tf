provider "aws" {
  region = "us-west-1" //N.California
}

resource "aws_instance" "Red_Hat" {

  ami           = "ami-00fc224d9834053d6"
  instance_type = "t2.micro"
  tags = {
    Name    = "Red_Hat_Server"
    Owner   = "Maksym Derbenov"
    Project = "Terraform Lesson"
  }
}
