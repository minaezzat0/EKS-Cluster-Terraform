output "azs" {
  description = "name of azs"
  value       = aws_subnet.public_subnet_task.availability_zone
}

output "vpc_id" {
  description = "name of vpc"
  value       = aws_vpc.vpc_task.id
}


output "private_subnet_id" {
  description = "name of vpc"
  value       = aws_subnet.private_subnet_task.id
}

output "public_subnet_id" {
  description = "name of vpc"
  value       = aws_subnet.public_subnet_task.id
}

output "security_group_id" {
  description = "name of security group"
  value       = aws_security_group.allow_tls.id
}
