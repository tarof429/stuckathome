provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-taro937184"
    key    = "global/s3/gitlab.tfstate"
    region = "us-west-2"

    dynamodb_table = "gitlab-locks"
    encrypt        = true
  }
}

resource "aws_instance" "gitlab_test_server" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name = "latest"
  security_groups = [aws_security_group.gitlab.name]
  # user_data = file("./install_gitlab.sh")

  tags = {
    Name = "Gitlab Test Server"
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "gitlab" {
  name   = "Gitlab Test Security Group"
  vpc_id = data.aws_vpc.default.id

  dynamic "ingress" {
    iterator = port
    for_each = var.ingressrules

    content {
      protocol    = "tcp"
      from_port   = port.value
      to_port     = port.value
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    iterator = port
    for_each = var.egressrules

    content {
      protocol    = "tcp"
      from_port   = port.value
      to_port     = port.value
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}