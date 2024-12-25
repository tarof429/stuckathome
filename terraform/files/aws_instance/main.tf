provider "aws" {
  region = "us-west-2"
}

//////////////////////////////////////////////////////////////
// Basic EC2 instance
//////////////////////////////////////////////////////////////
resource "aws_instance" "basic_server" {
  ami           = "ami-0d70546e43a941d70"
  instance_type = "t2.micro"

  tags = {
    Name = "instance-1"
  }
}

//////////////////////////////////////////////////////////////
// EC2 instance with basic security group
//////////////////////////////////////////////////////////////

resource "aws_instance" "instance_2" {
  ami             = "ami-0d70546e43a941d70"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.multiple_sg.name]

  tags = {
    Name = "instance-2"
  }
}

resource "aws_security_group" "multiple_sg" {
  name = "SG-2"

  tags = {
    Name = "SG-2"
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
  default = [22, 80]
}

variable "egressrules" {
  type    = list(number)
  default = [22, 80]
}

//////////////////////////////////////////////////////////////
// EC2 instance with VPC
//////////////////////////////////////////////////////////////
resource "aws_instance" "instance_3" {
  ami             = "ami-0604d81f2fd264c7b"
  instance_type   = "t2.micro"
  key_name        = "latest"
  security_groups = [aws_security_group.instance3_sg.id]
  subnet_id       = aws_subnet.instance3_public_subnet.id

  tags = {
    Name = "instance-3"
  }
}

resource "aws_eip" "instance_3_eip" {
  instance = aws_instance.instance_3.id
  tags = {
    Name = "instance3-eip"
  }
}

resource "aws_vpc" "instance_3_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "instance3-vpc"
  }
}

resource "aws_internet_gateway" "instance3_internet_gateway" {
  vpc_id = aws_vpc.instance_3_vpc.id

  tags = {
    Name = "instance-3-internet-gateway"
  }
}

resource "aws_route_table" "instance3_route_table" {
  vpc_id = aws_vpc.instance_3_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.instance3_internet_gateway.id
  }

  tags = {
    Name = "instance3-route-table"
  }
}

resource "aws_subnet" "instance3_public_subnet" {
  vpc_id            = aws_vpc.instance_3_vpc.id
  cidr_block        = "10.0.0.0/16"
  availability_zone = "us-west-2a"

  tags = {
    Name = "instance3-public-subnet"
  }
}

resource "aws_route_table_association" "instance3_route_table_association" {
  subnet_id      = aws_subnet.instance3_public_subnet.id
  route_table_id = aws_route_table.instance3_route_table.id
}

resource "aws_security_group" "instance3_sg" {
  name   = "Instance3 Security Group"
  vpc_id = aws_vpc.instance_3_vpc.id

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
