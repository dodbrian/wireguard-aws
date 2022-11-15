provider "aws" {
  region = "eu-north-1"
}

resource "aws_autoscaling_group" "wg_test_autoscaling_group" {
  name               = "wg_test_autoscaling_group"
  min_size           = 1
  max_size           = 1
  desired_capacity   = 1
  availability_zones = data.aws_availability_zones.wg_test_zones.names

  launch_template {
    id      = aws_launch_template.wg_test_launch_template.id
    version = "$Latest"
  }
}

resource "aws_launch_template" "wg_test_launch_template" {
  name                   = "wg_test_launch_template"
  image_id               = data.aws_ami.ubuntu-linux.id
  instance_type          = "t4g.nano"
  key_name               = "dodbrian-eu-north-1"
  update_default_version = true
  user_data              = filebase64("user-data.sh")

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      encrypted = true
    }
  }
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.wg_test_security_group.id]
  }

  instance_market_options {
    market_type = "spot"
  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.wg_test_instance_profile.arn
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      "Name" = "wg-test"
    }
  }

  tag_specifications {
    resource_type = "volume"

    tags = {
      "Name" = "wg-test"
    }
  }

  tag_specifications {
    resource_type = "network-interface"

    tags = {
      "Name" = "wg-test"
    }
  }

  tag_specifications {
    resource_type = "spot-instances-request"

    tags = {
      "Name" = "wg-test"
    }
  }
}

resource "aws_security_group" "wg_test_security_group" {
  name        = "wg_test_security_group"
  description = "WireGuard security group"

  tags = {
    "Name" = "wg_test_security_group"
  }

  ingress {
    cidr_blocks = ["178.6.229.122/32"]
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "WireGuard"
    from_port   = 51820
    to_port     = 51820
    protocol    = "udp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "WireGuard UI"
    from_port   = 51821
    to_port     = 51821
    protocol    = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
}

resource "aws_iam_instance_profile" "wg_test_instance_profile" {
  name = "wg_test_instance_profile"
  role = aws_iam_role.wg_test_role.name
}

resource "aws_iam_role" "wg_test_role" {
  name        = "wg_test_role"
  description = "Allows EC2 instances to call AWS services on your behalf."

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole"
        ],
        "Principal" : {
          "Service" : [
            "ec2.amazonaws.com"
          ]
        }
      }
    ]
  })

  inline_policy {
    name = "wg_test_s3_policy"

    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "s3:*"
          ],
          "Resource" : "*"
        }
      ]
    })
  }
}

data "aws_ami" "ubuntu-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  filter {
    name   = "name"
    values = ["*ubuntu*22.04*minimal*"]
  }
}

data "aws_availability_zones" "wg_test_zones" {
  state = "available"
}

terraform {
  backend "s3" {
    bucket         = "dodbrian-wireguard-aws-state"
    key            = "spot-instance/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "dodbrian-wireguard-aws-locks"
    encrypt        = true
  }
}
