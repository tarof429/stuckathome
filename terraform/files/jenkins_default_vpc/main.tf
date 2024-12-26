provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "jenkins" {
  ami           = var.ami
  instance_type = var.instance_type
  security_groups = [aws_security_group.cicd.name]
  tags = {
    Name = "jenkins"
  }
  user_data = "${path.module}/install_jenkins.sh"
  key_name = "latest"
}

resource "aws_security_group" "cicd" {
    name = "CI/CD"

    dynamic "ingress" {
        iterator = port 
        for_each = var.ingressrules
    
        content {
            protocol = "tcp"
            from_port = port.value
            to_port = port.value
            cidr_blocks = ["0.0.0.0/0"]   
        }
    }

    dynamic "egress" {
        iterator = port 
        for_each = var.egressrules
    
        content {
            protocol = "tcp"
            from_port = port.value
            to_port = port.value
            cidr_blocks = ["0.0.0.0/0"]   
        }
    }
}

output "jenkins_public_ip" {
    value = aws_instance.jenkins.public_ip
}