provider "aws" {
  region = "us-west-2"
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "test_security_group" {
  name = "test-security-group"
  vpc_id = data.aws_vpc.default.id
  tags = {
    Name = "TestSecurityGroup"
  }
}

data "http" "myip" {
  url = "https://ifconfig.me"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_rule" {
  security_group_id = aws_security_group.test_security_group.id
  // cidr_ipv4 = "0.0.0.0/0"
  cidr_ipv4 = "${data.http.myip.response_body}/32"
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}

output "my_public_ip" {
    value = data.http.myip.response_body
}