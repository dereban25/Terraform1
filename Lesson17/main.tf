provider "aws" {
  region = "us-west-1"
  alias  = "USA"
}
provider "aws" {
  region = "ca-central-1"
  alias  = "Canada"
}
provider "aws" {
  region = "eu-central-1"
  alias  = "Germany"
}
data "aws_ami" "usa_latest" {
  provider    = aws.USA
  owners      = [ "309956199498" ]
  most_recent = true
  filter {
	name   = "name"
	values = [ "RHEL-*-x86_64*" ]
  }
}
data "aws_ami" "canada_latest" {
  provider    = aws.Canada
  owners      = [ "099720109477" ]
  most_recent = true
  filter {
	name   = "name"
	values = [ "ubuntu-minimal/images-testing/hvm-ssd/ubuntu-bionic-daily-amd64-minimal-*" ]
  }
}
resource "aws_instance" "server_USA" {
  provider      = aws.USA
  ami           = data.aws_ami.usa_latest.id
  instance_type = "t2.micro"
  tags          = {
	Name  = "Server USA"
	Owner = "RedHat"
  }
}
resource "aws_instance" "Canada_server" {
  provider      = aws.Canada
  ami           = data.aws_ami.canada_latest.id
  instance_type = "t2.micro"
  tags          = {
	Name  = "Server Canada"
	Owner = "Ubuntu"
  }
}
resource "aws_instance" "Germany_server" {
  provider      = aws.Germany
  ami           = "ami-0cc293023f983ed53"
  instance_type = "t2.micro"
  tags          = {
	Name  = "Server Germany"
	Owner = "Amazon_Linux"
  }
}