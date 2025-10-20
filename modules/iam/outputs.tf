output "iam_role_name" {
  description = "Name of IAM Role"
  value       = aws_iam_role.ec2_role.name
}

output "instance_profile_name" {
  description = "Name of IAM Instance Profile"
  value       = aws_iam_instance_profile.ec2_instance_profile.name
}

output "policy_arn" {
  description = "IAM Policy ARN"
  value       = aws_iam_policy.ec2_policy.arn
}
