provider "aws" {}

data "aws_availability_zones" "working" {}
data "aws_caller_identity" "working" {}
data "aws_region" "current" {}
data "aws_vpcs" "my_vpcs" {}
data "aws_vpc" "california_vpc" {
  tags = {
    Name = "California"
  }
}
#########Show VPC account#########
output "california_vpc_id" {
  value = data.aws_vpc.california_vpc.id
}
output "california_vpc_cidr" {
  value = data.aws_vpc.california_vpc.cidr_block
}
output "aws_vpcs" {
  value = data.aws_vpcs.my_vpcs.ids
}
#########Create VPC region#########
resource "aws_subnet" "California_subnet_1" {
  cidr_block = "10.0.1.0/24"
  vpc_id = data.aws_vpc.california_vpc.id
  availability_zone = data.aws_availability_zones.working.names[0]
  tags = {
    Name = "Subnet 1 in ${data.aws_availability_zones.working.names[0]}"
    Account = "Subnet 2 for ${data.aws_caller_identity.working.account_id}"
    Region = "Region is ${data.aws_region.current.description}"
  }
}
resource "aws_subnet" "California_subnet_2" {
  cidr_block = "10.0.2.0/24"
  vpc_id = data.aws_vpc.california_vpc.id
  availability_zone = data.aws_availability_zones.working.names[1]
  tags = {
    Name = "Subnet 2 in ${data.aws_availability_zones.working.names[1]}"
    Account = "Subnet 2 for ${data.aws_caller_identity.working.account_id}"
    Region = "Region is ${data.aws_region.current.description}"
  }
}
#########Show availability zones and region############
output "data_aws_availability_zones" {
  value = data.aws_availability_zones.working.names
}
output "data_aws_region_name" {
  value = data.aws_region.current.description
}
#########Show Caller Identity###############
output "data_aws_caller_indenfity" {
  value = data.aws_caller_identity.working.account_id
}
output "data_aws_caller_user_id" {
  value = data.aws_caller_identity.working.user_id
}


