provider "aws" {
  region = "us-west-1"
}
data "aws_region" "current" {}
data "aws_availability_zones" "available" {}
locals {
  full_project_name = "${var.project_name} ${var.environment}"
  project_owner     = "${var.owner} owner of ${var.project_name}"
  country           = "USA"
  city              = "North California is in "
  az_list           = join(":", data.aws_availability_zones.available.names)
  region            = data.aws_region.current.description
  location          = "In ${local.region} there are AZ: ${local.az_list}"

}
resource "aws_eip" "static_ip" {
  tags = {
    Name          = "My static IP"
    Owner         = var.owner
    Project       = local.full_project_name
    Owner_Project = local.project_owner
    City          = "${local.city}${local.country}"
    region_azs    = local.az_list
    location_azs  = local.location
  }
}