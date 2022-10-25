provider "aws" {
  region = "eu-north-1"
}

resource "aws_eip" "eip" {
  vpc = true

  tags = {
    "Name" = "wg-aws"
  }
}
