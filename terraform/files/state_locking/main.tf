terraform {
  backend "s3" {
    bucket = "tarof429-terraform-state"
    region = "us-west-2"
    key    = "state_locking"
  }
}
provider "aws" {
  region = "us-west-2"
}

resource "aws_security_group" "test_security_group" {
  name = "Allow SSH"

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
}