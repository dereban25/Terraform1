output "web_sg_id" {
  value = aws_security_group.webserver.id
}
output "web_server_public_ip" {
  value = aws_instance.server.public_ip
}