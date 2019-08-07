output "instance_id" {
  value = aws_instance.Web_Server.id
}

output "webserver_ip_address" {
  value = aws_eip.elastic_ip.public_ip
}

output "webserver_sq_id" {
  value = aws_security_group.Security_Web_Server.id
}
output "webserver_sq_arn" {
  value = aws_security_group.Security_Web_Server.arn
}
