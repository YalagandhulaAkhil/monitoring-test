output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "Public Subnet ID"
  value       = aws_subnet.public.id
}

output "security_group_id" {
  description = "Main Security Group ID"
  value       = aws_security_group.main_sg.id
}
