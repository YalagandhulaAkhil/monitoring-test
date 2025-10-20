output "dashboard_name" {
  description = "Name of the CloudWatch Dashboard"
  value       = aws_cloudwatch_dashboard.main_dashboard.dashboard_name
}

output "cpu_alarm_name" {
  description = "Name of the CPU utilization alarm"
  value       = aws_cloudwatch_metric_alarm.cpu_alarm.alarm_name
}

output "log_group_name" {
  description = "Name of the CloudWatch Log Group"
  value       = aws_cloudwatch_log_group.ec2_log_group.name
}
