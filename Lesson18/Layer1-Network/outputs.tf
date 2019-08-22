output "vpc_id" {
  value = aws_vpc.main.id
}
output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}
output "public_id_sub" {
  value = aws_subnet.public_subnet[ * ].id
}