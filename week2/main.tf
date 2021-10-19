terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.63.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
  access_key = "AKIAWZBMVCVDD3CUS35B"
  secret_key = "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"
}

# Security group
resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow WEB inbound traffic"

  ingress = [
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    },
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    }
  ]

  egress = [
    {
      description = "all allowed"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = []
      security_groups = []
      self = false
    }
  ]

  tags = {
    Name = "allow_HTTP"
  }
}

# Auto scaling group
resource "aws_autoscaling_group" "MyAutoScalingGroup" {
    name = "my-auto-scaling-group"
    availability_zones = [ "us-west-2a", "us-west-2b", "us-west-2c" ]
    launch_template {
      id = aws_launch_template.MyLaunchTemplate.id
      version = "$Latest"
    }

    min_size = 2
    max_size = 4
    desired_capacity = 2
    health_check_grace_period = 300
}

resource "aws_launch_template" "MyLaunchTemplate" {
    image_id = "ami-0c2d06d50ce30b442"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.allow_web.id ,aws_security_group.allow_web.id ]
    user_data = filebase64("${path.module}/files/ec2-startup.sh")
    key_name = "aws_key_pair"
    iam_instance_profile {
      name = "${aws_iam_instance_profile.s3_profile.name}"
    }
}

# IAM
resource "aws_iam_role" "ec2_s3_access_role" {
  name               = "s3-role"
  assume_role_policy = "${file("files/assumerolepolicy.json")}"
}

resource "aws_iam_policy" "s3policy" {
  name        = "s3FullAccess"
  description = "s3FullAccess policy"
  policy      = "${file("files/policys3bucket.json")}"
}

resource "aws_iam_policy_attachment" "s3PolicyAttach" {
  name       = "s3-attachment"
  roles      = ["${aws_iam_role.ec2_s3_access_role.name}"]
  policy_arn = "${aws_iam_policy.s3policy.arn}"
}

resource "aws_iam_instance_profile" "s3_profile" {
  name  = "s3_profile"
  role = "${aws_iam_role.ec2_s3_access_role.name}"
}

