
resource "aws_instance" "gitlab_app_server" {
  ami             = var.server_ami
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [aws_security_group.gitlab_sg.id]
  subnet_id       = aws_subnet.gitlab_public_subnet.id

  tags = {
    Name = "gitlab-appserver"
  }
}

resource "aws_eip" "gitlab_appserver_eip" {
  instance = aws_instance.gitlab_test_server.id
  tags = {
    Name = "gitlab-appserver-eip"
  }
}

resource "aws_vpc" "gitlab_appserver_vpc" {
  cidr_block = var.public_vpc_cidr_block
  tags = {
    Name = "gitlab-appserver-vpc"
  }
}

resource "aws_internet_gateway" "gitlab_internet_gateway" {
  vpc_id = aws_vpc.gitlab_appserver_vpc.id

  tags = {
    Name = "gitab-internet-gateway"
  }
}

resource "aws_route_table" "gitlab_route_table" {
  vpc_id = aws_vpc.gitlab_appserver_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gitlab_internet_gateway.id
  }

  tags = {
    Name = "gitlab-route-table"
  }
}

resource "aws_subnet" "gitlab_gitlab_public_subnet" {
  vpc_id            = aws_vpc.gitlab_appserver_vpc.id
  cidr_block        = var.public_vpc_cidr_block
  availability_zone = "us-west-2a"

  tags = {
    Name = "gitlab-public-subnet"
  }
}

resource "aws_route_table_association" "gitlab_route_table_association" {
  subnet_id      = aws_subnet.gitlab_public_subnet.id
  route_table_id = aws_route_table.gitlab_route_table.id
}

resource "aws_security_group" "gitlab_sg" {
  name   = "Gitlab AppServer Security Group"
  vpc_id = aws_vpc.gitlab_appserver_vpc.id

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
