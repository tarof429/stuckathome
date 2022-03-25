terraform {

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_instance" "app_server" {
  ami             = "ami-0892d3c7ee96c0bf7"
  instance_type   = "t2.micro"
  key_name        = var.key_name
  security_groups = ["simple-security-group"]

  user_data = <<EOF
        #!/bin/bash
        sudo apt update && \
        sudo apt upgrade -y && \
        sudo apt install -y vim
    EOF

  tags = {
    Name = var.instance_tag
  }
}
