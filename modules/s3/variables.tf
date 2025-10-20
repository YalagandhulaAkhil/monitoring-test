variable "bucket_name" {
  description = "The name of the S3 bucket to store module outputs"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g. dev, prod)"
  type        = string
  default     = "dev"
}
