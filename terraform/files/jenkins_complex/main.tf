provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "jenkins" {
  ami           = var.ami
  instance_type = var.instance_type
  security_groups = [aws_security_group.cicd.id]
  tags = {
    Name = "jenkins"
  }
  user_data = file("./install_jenkins.sh")
  key_name = "latest"

  subnet_id = aws_subnet.public_subnet.id
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
        Name = "Jenkins Route Table"
    }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.jenkins_vpc.id
    cidr_block = var.public_subnet_cidr

    tags = {
        Name = "Public Subnet"
    }
}

resource "aws_route_table_association" "jenkins_route_table_association" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.jenkins_route_table.id
}

resource "aws_security_group" "cicd" {
    name = "CI/CD"
    vpc_id = aws_vpc.jenkins_vpc.id

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