provider "aws" {
  region = "us-west-2"
}

data "http" "myip" {
  url = "https://ifconfig.me"
}

resource "aws_instance" "jenkins" {
  ami           = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  tags = {
    Name = "jenkins"
  }
  user_data = "${path.module}/install_jenkins.sh"
  key_name = "latest"
}

resource "aws_security_group" "jenkins_sg" {
    name = "Jenkins SG"

    dynamic "ingress" {
        iterator = port 
        for_each = var.ingressrules
    
        content {
            protocol = "tcp"
            from_port = port.value
            to_port = port.value
            //cidr_blocks = ["0.0.0.0/0"]
            cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
        }
    }
}

resource "aws_vpc_security_group_egress_rule" "jenkins_sg" {
  security_group_id = aws_security_group.jenkins_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  to_port           = 0
  ip_protocol       = -1
}

output "jenkins_public_ip" {
    value = aws_instance.jenkins.public_ip
}