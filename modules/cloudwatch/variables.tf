variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment (dev/prod)"
  type        = string
}

variable "instance_id" {
  description = "EC2 instance ID to monitor"
  type        = string
}

variable "alarm_topic_arn" {
  description = "SNS topic ARN to send CloudWatch alarm notifications"
  type        = string
  default     = ""
}
