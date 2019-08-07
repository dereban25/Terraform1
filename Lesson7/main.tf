provider "aws" {}

data "aws_availability_zones" "working" {}
data "aws_caller_identity" "working" {}
data "aws_region" "current" {}
data "aws_vpcs" "my_vpcs" {}
output "data_aws_availability_zones" {
  value = data.aws_availability_zones.working.names
}
output "data_aws_caller_indenfity" {
  value = data.aws_caller_identity.working.account_id
}
output "data_aws_caller_user_id" {
  value = data.aws_caller_identity.working.user_id
}
output "data_aws_region_name" {
  value = data.aws_region.current.description
}
output "aws_vpcs" {
  value = data.aws_vpcs.my_vpcs.ids
}
