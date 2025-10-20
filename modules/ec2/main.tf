# Get the latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

# EC2 Instance
resource "aws_instance" "web_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  key_name                    = var.key_name
  iam_instance_profile        = var.instance_profile_name
  associate_public_ip_address = true
  monitoring                  = true  # Enable CloudWatch detailed monitoring

  tags = {
    Name        = "${var.project}-ec2-${var.environment}"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y nginx awscli cloudwatch-agent
              systemctl enable nginx
              systemctl start nginx
              EOF
}

# Optional EBS Volume Attachment
resource "aws_ebs_volume" "extra_storage" {
  availability_zone = var.availability_zone
  size              = var.ebs_volume_size
  type              = "gp3"

  tags = {
    Name = "${var.project}-ebs-${var.environment}"
  }
}

resource "aws_volume_attachment" "attach_storage" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.extra_storage.id
  instance_id = aws_instance.web_server.id
}
