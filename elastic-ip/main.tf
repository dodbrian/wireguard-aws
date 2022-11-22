provider "aws" {
  region = "eu-north-1"
}

resource "aws_eip" "wg_test_eip" {
  vpc = true

  tags = {
    "Name" = "wg-aws"
  }
}
