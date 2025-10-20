variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment (e.g. dev/prod)"
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN of S3 bucket used for output storage"
  type        = string
}
