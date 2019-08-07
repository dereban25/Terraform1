//----Web_Server----//
provider "aws" {
  region = "us-west-1" //N.California
}

resource "aws_instance" "Web_Server" {
  ami                    = "ami-08fd8ae3806f09a08" #Amazon linux AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.Security_Web_Server.id]
  user_data              = <<EOF
  #!/bin/bash
  yum -y update
  yum -y install httpd
  myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
  echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform!"  >  /var/www/html/index.html
  sudo service httpd start
  chkconfig httpd on
  EOF

  tags {
    Name = "Web Server Build by Terraform"
    Owner = "Maksym Derbenev"
  }
}

resource "aws_security_group" "Security_Web_Server" {
  name = "Security group for Web"
  description = "Test security of Terraform"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
