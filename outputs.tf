output "vpc_id" {
  value = module.vpc.vpc_id
}

output "ec2_public_ip" {
  value = module.ec2.public_ip
}

output "s3_output_bucket" {
  value = module.s3.bucket_name
}

output "cloudwatch_dashboard" {
  value = module.cloudwatch.dashboard_name
}
