##1.Create Security Group for Web server
##2.       Launch with auto AMI
##3.       Auto-scaling 2 availability Zones
##4.       Load Balancer 2 availability Zones
#################Found AMI#######################
provider "aws" {
  region = "us-west-1"
  version = "~>2.0"
}

data "aws_availability_zones" "for_web"{}
data "aws_ami" "id_RedHat" {
  owners = ["309956199498"]
  most_recent = true
  filter {
    name = "name"
    values = ["RHEL-8.0.0_HVM-*-x86_64-1*"]
  }
}
###################Create Security Group##########
resource "aws_security_group" "Web_Server" {
  name = "Dymanic Security group"

  dynamic "ingress" {
    for_each = ["80", "443", "8080", "143"]

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
###########Launch with AMI#####################
resource "aws_launch_configuration" "server" {
  name_prefix = "WebServer-High-"
  image_id = data.aws_ami.id_RedHat.id
  instance_type = "t2.micro"
  security_groups = [aws_security_group.Web_Server.id]
  user_data = file("user_data.sh")
  lifecycle {
    create_before_destroy = true
  }
}
###########Auto-scaling group#####################
resource "aws_autoscaling_group" "web" {
  name = "Webser for High-${aws_launch_configuration.server.name}"
  launch_configuration = aws_launch_configuration.server.name
  max_size = 2
  min_size = 2
  min_elb_capacity = 2
  vpc_zone_identifier = [aws_default_subnet.default_az1.id,aws_default_subnet.default_az2.id]
  health_check_type = "ELB"
  load_balancers = [aws_elb.Web.name]

  dynamic "tag" {
    for_each = {
      Name = "WebServer in ASG"
      Owner = "Maks Derbenev"
      TAGKEY = "TAGVALUE"
    }
    content {
      key = tag.key
      value = tag.value
      propagate_at_launch = true
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}
##########Load Balancer####################
resource "aws_elb" "Web" {
  name = "WebServer-On-ELB"
  availability_zones = [data.aws_availability_zones.for_web.names[0],data.aws_availability_zones.for_web.names[1]]
  security_groups = [aws_security_group.Web_Server.id]
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  health_check {
    healthy_threshold = 2
    interval = 10
    target = "HTTP:80/"
    timeout = 3
    unhealthy_threshold = 2
  }
  tags = {
    Name = "Webserver-High-ELB"
  }
}
###########Create subnet in Availability Zones#####################
resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.for_web.names[0]
}
resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.for_web.names[1]
}
############Show information about DNS name of Web Server###########
output "web_loadbalancer_url" {
  value = aws_elb.Web.dns_name
}
