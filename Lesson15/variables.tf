variable "env" {
  default = "dev"
}
variable "prod_owner" {
  default = "Maks Derbenev"
}
variable "noprod_owner" {
  default = "Timofey Derbenev"
}
variable "ec2_size" {
  default = {
	"prod"    = "t3.medium"
	"dev"     = "t3.micro"
	"staging" = "t2.small"
  }
}
variable "allow_ports" {
  default = {
	"prod" = [ "80", "443" ]
	"dev"  = [ "80", "442", "8080", "22" ]
  }
}