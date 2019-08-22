provider "aws" {
  region = "us-west-1"
}
terraform {
  backend "s3" {
	bucket = "dereban-terraform"
	key    = "dev/servers/terraform.tfstate"
	region = "us-west-1"
  }
}
data "terraform_remote_state" "network" {
  backend = "s3"
  config  = {
	bucket = "dereban-terraform"
	key    = "dev/network/terraform.tfstate"
	region = "us-west-1"
  }
}
data "aws_ami" "id_RedHat" {
  owners      = [ "309956199498" ]
  most_recent = true
  filter {
	name   = "name"
	values = [ "RHEL-8.0.0_HVM-*-x86_64-1*" ]
  }
}
resource "aws_instance" "server" {
  ami                    = data.aws_ami.id_RedHat.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [ aws_security_group.webserver.id ]
  subnet_id              = data.terraform_remote_state.network.outputs.public_id_sub[ 0 ]
  user_data              = <<EOF
#!/bin/bash
sudo yum -y update
sudo yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform!"  >  /var/www/html/index.html
sudo service httpd start
sudo chkconfig httpd on
EOF

  tags = {
	Name  = "Web Server Build by Terraform"
	Owner = "Maksym Derbenev"
  }
}
resource "aws_security_group" "webserver" {
  name   = "Security for Web"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id
  ingress {
	from_port   = 80
	protocol    = "tcp"
	to_port     = 80
	cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
	from_port   = 22
	protocol    = "tcp"
	to_port     = 22
	cidr_blocks = [ data.terraform_remote_state.network.outputs.vpc_cidr ]
  }
  egress {
	from_port   = 0
	protocol    = "-1"
	to_port     = 0
	cidr_blocks = [ "0.0.0.0/0" ]
  }
}
