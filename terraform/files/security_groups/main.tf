provider "aws" {
  region = "us-west-2"
}

data "aws_vpc" "default" {
  default = true
}

data "http" "myip" {
  url = "https://ifconfig.me"
}


//////////////////////////////////////////////////////////////
// Security Group that doesn't allow any access
//////////////////////////////////////////////////////////////
resource "aws_security_group" "sg_with_no_inbound_rules" {
  name   = "SG-1"
  vpc_id = data.aws_vpc.default.id
  tags = {
    Name = "SG-1"
  }
}

//////////////////////////////////////////////////////////////
// Security Group that allows port 22 to all IPs
//////////////////////////////////////////////////////////////
resource "aws_security_group" "sg_with_open_inbound_rules" {
  name   = "SG-2"
  vpc_id = data.aws_vpc.default.id
  tags = {
    Name = "SG-2"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_rule" {
  security_group_id = aws_security_group.sg_with_open_inbound_rules.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

//////////////////////////////////////////////////////////////
// Security Group that allows multiple ports
//////////////////////////////////////////////////////////////
resource "aws_security_group" "multiple_sg" {
  name = "SG-3"

  tags = {
    Name = "SG-3"
  }

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

variable "ingressrules" {
  type    = list(number)
  default = [22, 80, 8080, 8443]
}

variable "egressrules" {
  type    = list(number)
  default = [22, 80, 8080, 8443]
}

//////////////////////////////////////////////////////////////
// Security group with mulitple ports and a discovered public IP
//////////////////////////////////////////////////////////////
resource "aws_security_group" "dynamic_sg" {
  name = "SG-4"

  tags = {
    Name = "SG-4"
  }

  dynamic "ingress" {
    iterator = port
    for_each = var.ingressrules2

    content {
      protocol    = "tcp"
      from_port   = port.value
      to_port     = port.value
      cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
    }
  }

  dynamic "egress" {
    iterator = port
    for_each = var.egressrules2

    content {
      protocol    = "tcp"
      from_port   = port.value
      to_port     = port.value
      cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
    }
  }
}

variable "ingressrules2" {
  type    = list(number)
  default = [22, 8889]
}

variable "egressrules2" {
  type    = list(number)
  default = [22, 8889]
}

//////////////////////////////////////////////////////////////
// Print my public IP
//////////////////////////////////////////////////////////////
output "my_public_ip" {
  value = data.http.myip.response_body
}
