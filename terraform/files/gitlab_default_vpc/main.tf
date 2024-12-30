provider "aws" {
  region = "us-west-2"
}

data "http" "myip" {
  url = "https://ifconfig.me"
}

resource "aws_instance" "gitlab" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name = "latest"
  vpc_security_group_ids = [aws_security_group.gitlab_sg.id]
  //user_data = file("./install_gitlab.sh")

  tags = {
    Name = "Gitlab"
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "gitlab_sg" {
  name   = "Gitlab SG"

  dynamic "ingress" {
    iterator = port
    for_each = var.ingressrules

    content {
      protocol    = "tcp"
      from_port   = port.value
      to_port     = port.value
      cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
    }
  }
}

resource "aws_vpc_security_group_egress_rule" "gitlab_sg" {
  security_group_id = aws_security_group.gitlab_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = -1
  to_port           = -1
  ip_protocol       = -1
}
