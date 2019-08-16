output "created_aws_users" {
  value = aws_iam_user.create_user[ * ].id
}
output "create_custom" {
  value = [
  for user in aws_iam_user.create_user:
  "Username: ${user.name} has ARN: ${user.arn}"
  ]
}
output "create_maps" {
  value = {
  for user1 in aws_iam_user.create_user:
  user1.unique_id => user1.id
  }
}
output "check_lenght" {
  value = [
  for x in aws_iam_user.create_user:
  x.name
  if length(x.name) <= 6 ]
}
output "server_all" {
  value = {
  for server in aws_instance.bastion_server:
  server.tags.Name => server.public_ip
  }
}