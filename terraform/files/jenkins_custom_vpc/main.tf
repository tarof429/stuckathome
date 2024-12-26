provider "aws" {
  region = "us-west-2"
}

data "http" "myip" {
  url = "https://ifconfig.me"
}

// Jenkins listens on port 8080
resource "aws_instance" "jenkins" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = "latest"
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id] // Note that we need to use 'vpc_security_group_ids' instead of 'security_groups' for a custom VPC

  tags = {
    Name = "jenkins"
  }

  // user_data = file("./install_jenkins.sh")
}

resource "aws_eip" "jenkins_eip" {
  instance = aws_instance.jenkins.id
}

resource "aws_vpc" "jenkins_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "Jenkins VPC"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.jenkins_vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = "us-west-2a"

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_internet_gateway" "jenkins_internet_gateway" {
  vpc_id = aws_vpc.jenkins_vpc.id

  tags = {
    Name = "Jenkins Internet Gateway"
  }
}

resource "aws_route_table" "jenkins_route_table" {
  vpc_id = aws_vpc.jenkins_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.jenkins_internet_gateway.id
  }

  tags = {
    Name = "Jenkins Public Route Table"
  }
}

resource "aws_route_table_association" "jenkins_route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.jenkins_route_table.id
}

resource "aws_security_group" "jenkins_sg" {
  name   = "Jenkins SecurityGroup"
  vpc_id = aws_vpc.jenkins_vpc.id

  dynamic "ingress" {
    iterator = port
    for_each = var.ingressrules

    content {
      protocol  = "tcp"
      from_port = port.value
      to_port   = port.value
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
  value = aws_eip.jenkins_eip.public_ip
}