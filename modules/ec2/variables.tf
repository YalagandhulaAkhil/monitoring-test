variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name (dev/prod)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet ID for EC2 instance"
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID"
  type        = string
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
}

variable "iam_role_name" {
  description = "IAM Role name to attach to EC2"
  type        = string
}

variable "instance_profile_name" {
  description = "IAM Instance Profile name"
  type        = string
}

variable "availability_zone" {
  description = "Availability Zone"
  type        = string
  default     = "us-east-1a"
}

variable "ebs_volume_size" {
  description = "Size of additional EBS volume in GB"
  type        = number
  default     = 5
}
