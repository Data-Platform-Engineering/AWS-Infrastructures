output "aws_security_group_id" {
  value = aws_security_group.allow_access.id
  
}
output "subnet_id" {
  value = aws_subnet.main.id
}
