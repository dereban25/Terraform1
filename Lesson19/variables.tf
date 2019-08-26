variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "env" {
  default = "dev"
}
variable "public_subnets" {
  default = [ "10.0.0.1/24", "10.0.0.2/24" ]
}
variable "private_subnets" {
  default = [ "10.0.11.0/24", "10.0.12.0/24" ]
}