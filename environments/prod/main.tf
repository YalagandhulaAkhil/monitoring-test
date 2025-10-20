terraform {
  backend "s3" {
    bucket         = "tf-monitoring-backend-bucket"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}

# ---------------- Modules ---------------- #

module "s3" {
  source      = "../../modules/s3"
  bucket_name = "tf-monitoring-output-prod"
  environment = "prod"
}

module "vpc" {
  source             = "../../modules/vpc"
  project            = var.project
  environment        = "prod"
  vpc_cidr           = "10.20.0.0/16"
  public_subnet_cidr = "10.20.1.0/24"
  availability_zone  = "us-east-1b"
}

module "iam" {
  source       = "../../modules/iam"
  project      = var.project
  environment  = "prod"
  s3_bucket_arn = module.s3.bucket_arn
}

module "ec2" {
  source                = "../../modules/ec2"
  project               = var.project
  environment           = "prod"
  instance_type         = "t3.small"
  subnet_id             = module.vpc.subnet_id
  security_group_id     = module.vpc.security_group_id
  key_name              = var.key_name
  iam_role_name         = module.iam.iam_role_name
  instance_profile_name = module.iam.instance_profile_name
  availability_zone     = "us-east-1b"
}

module "cloudwatch" {
  source         = "../../modules/cloudwatch"
  project        = var.project
  environment    = "prod"
  instance_id    = module.ec2.instance_id
  alarm_topic_arn = var.alarm_topic_arn
}
