provider "aws" {
  region = "eu-north-1"
}

# resource "aws_spot_instance_request" "instance" {
#   instance_type        = "t4g.nano"
#   ami                  = "ami-05479cdbcb6e73038"
#   spot_type            = "persistent"
#   wait_for_fulfillment = true
# }

# resource "aws_launch_template" "wg-server-template" {
#   name          = "wg-server-template"
#   image_id      = "ami-05479cdbcb6e73038"
#   instance_type = "t4g.nano"

#   instance_market_options {
#     market_type = "spot"
#   }
# }

resource "aws_instance" "wg_test_instance" {
  instance_type               = "t4g.nano"
  ami                         = data.aws_ami.ubuntu-linux.id
  associate_public_ip_address = true
  security_groups             = [aws_security_group.wg_test_security_group.name]
  iam_instance_profile        = aws_iam_instance_profile.wg_test_instance_profile.name
  key_name                    = "dodbrian-eu-north-1"
  user_data                   = filebase64("user-data.sh")

  root_block_device {
    encrypted = true
  }

  tags = {
    "Name" = "wg-test"
  }
}

resource "aws_iam_instance_profile" "wg_test_instance_profile" {
  name = "wg_test_instance_profile"
  role = aws_iam_role.wg_test_role.name
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

terraform {
  backend "s3" {
    bucket         = "dodbrian-wireguard-aws-state"
    key            = "spot-instance/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "dodbrian-wireguard-aws-locks"
    encrypt        = true
  }
}
