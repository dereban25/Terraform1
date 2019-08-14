variable "country" {
  description = "Please enter region for server"
  type = string
  default     = "us-west-1"
}
variable "Type_server" {
  description = "Type server for instance"
  type = string
  default = "t2.micro"
}
variable "port_for_server" {
  description = "Create security group with ports"
  type = list
  default = ["80", "443", "22"]
}
variable "Detail_monitoring" {
  type = bool
  default = false
}
variable "com_tags" {
  description = "Name and tags for server"
  type = map
  default = {
    Owner = "Maks Derbenev"
    Project = "Terra for AWS"
    Enviroment = "Development"
  }
}