#########Find latest AMI id of Ubuntu,Amazon Linux,Server 2016########
provider "aws" {
  version = "~> 2.0"
  region = "ap-southeast-1"
}
############Find for Ubuntu###################
data "aws_ami" "id_ubuntu" {
  owners = ["099720109477"]
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}
output "latest_ubuntu_ami_id" {
  value = data.aws_ami.id_ubuntu.id
}
output "latest_ubuntu_ami_name" {
  value = data.aws_ami.id_ubuntu.name
}
############Find for Amazon###################
data "aws_ami" "id_amazon" {
  owners = ["amazon"]
  most_recent = true
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
output "latest_amazon_ami_id" {
  value = data.aws_ami.id_amazon.id
}
output "latest_amazon_ami_name" {
  value = data.aws_ami.id_amazon.name
}
############Find for RedHat###################
data "aws_ami" "id_RedHat" {
  owners = ["309956199498"]
  most_recent = true
  filter {
    name = "name"
    values = ["RHEL-8.0.0_HVM-*-x86_64-1*"]
  }
}
output "latest_RedHat_ami_id" {
  value = data.aws_ami.id_RedHat.id
}
output "latest_RedHat_ami_name" {
  value = data.aws_ami.id_RedHat.name
}
############Find for Windows###################
data "aws_ami" "id_Windows" {
  owners = ["amazon"]
  most_recent = true
  filter {
    name = "name"
    values = ["Windows_Server-2016-English-Full-Base*"]
  }
}
output "latest_Windows_ami_id" {
  value = data.aws_ami.id_Windows.id
}
output "latest_Windows_ami_name" {
  value = data.aws_ami.id_Windows.name
}
resource "aws_instance" "Create_with_ami" {
  ami                    = data.aws_ami.id_amazon.id #Amazon linux AMI
  instance_type          = "t2.micro"
}