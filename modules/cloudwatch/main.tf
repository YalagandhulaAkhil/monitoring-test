# Create a CloudWatch Log Group for EC2
resource "aws_cloudwatch_log_group" "ec2_log_group" {
  name              = "/aws/ec2/${var.project}-${var.environment}"
  retention_in_days = 14

  tags = {
    Name        = "${var.project}-ec2-log-group"
    Environment = var.environment
  }
}

# Metric Alarm: CPU Utilization
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "${var.project}-cpu-utilization-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Triggers if EC2 CPU > 70% for 2 minutes"
  alarm_actions       = [var.alarm_topic_arn]
  dimensions = {
    InstanceId = var.instance_id
  }

  tags = {
    Environment = var.environment
  }
}

# Metric Alarm: Disk Read Ops (example)
resource "aws_cloudwatch_metric_alarm" "disk_alarm" {
  alarm_name          = "${var.project}-disk-readops-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "DiskReadOps"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Sum"
  threshold           = 200
  alarm_description   = "Triggers if DiskReadOps > 200"
  alarm_actions       = [var.alarm_topic_arn]
  dimensions = {
    InstanceId = var.instance_id
  }

  tags = {
    Environment = var.environment
  }
}

# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "main_dashboard" {
  dashboard_name = "${var.project}-dashboard-${var.environment}"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric",
        x    = 0,
        y    = 0,
        width = 12,
        height = 6,
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", var.instance_id],
            ["AWS/EC2", "NetworkIn", "InstanceId", var.instance_id],
            ["AWS/EC2", "NetworkOut", "InstanceId", var.instance_id]
          ]
          period = 60
          stat   = "Average"
          title  = "EC2 Performance Metrics"
        }
      }
    ]
  })
}
