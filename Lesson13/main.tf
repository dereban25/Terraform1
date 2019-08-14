provider "aws" {
  region = "us-west-1"
}

resource "null_resource" "com1" {
  provisioner "local-exec" {
	command = "echo Terraform START: $(date) >> log.txt"
  }
}
resource "null_resource" "com2" {
  provisioner "local-exec" {
	command = "ping -c 5 www.google.com"
  }
  depends_on = [
	null_resource.com1]
}
resource "null_resource" "com3" {
  provisioner "local-exec" {
	command     = "print('Hello mister dereban')"
	interpreter = [
	  "python",
	  "-c"]
  }
}
resource "null_resource" "com4" {
  provisioner "local-exec" {
	command     = "echo $NAME1$'\n'$NAME2$'\n'$NAME3 >> names.txt"
	environment = {
	  NAME1 = "Peya"
	  NAME2 = "Natasha"
	  NAME3 = "Timofey"
	}
  }
}
data "aws_ami" "Red_Hat" {
  owners      = [
	"309956199498"]
  most_recent = true
  filter {
	name   = "name"
	values = [
	  "RHEL-8.0.0_HVM-*-x86_64-1*"]
  }
}
resource "aws_instance" "server" {
  ami           = data.aws_ami.Red_Hat.id
  instance_type = "t2.micro"
  provisioner "local-exec" {
	command = "echo Hello from AWS Instance Credentions"
  }
}
resource "null_resource" "com6" {
  provisioner "local-exec" {
	command = "echo Terraform END: $(date) >> log.txt"
  }
  depends_on = [
	null_resource.com1,
	null_resource.com2,
	null_resource.com3,
	null_resource.com4,
	aws_instance.server]
}
