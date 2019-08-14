###Show informantion an IP of Server
output "server_ip" {
  value = aws_eip.elastic_ip.public_ip
}
###Show informantion an ID of Server
output "instance_id" {
  value = aws_instance.Server.id
}
###Show informantion an ID of Security Group
output "Security_Group" {
  value = aws_security_group.Server.id
}