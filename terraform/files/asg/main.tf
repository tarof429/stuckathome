provider "aws" {
  region = "us-west-2"
}

variable "server_port" {
  type        = number
  description = "HTTP port of web server"
  default     = 8080
}

variable "ssh_port" {
  type        = number
  description = "SSH port to web server"
  default     = 22
}

variable "ingressrules" {
  type    = list(number)
  default = [22, 8080]
}

variable "egressrules" {
  type    = list(number)
  default = [22, 8080]
}

resource "aws_autoscaling_group" "example" {
  availability_zones = ["us-west-2a", "us-west-2b"]
  desired_capacity   = 2
  max_size           = 2
  min_size           = 1

  launch_template {
    id      = aws_launch_template.my_launch_template.id
    version = "$Latest"
  }
}

resource "aws_launch_template" "my_launch_template" {
  name_prefix   = "my_launch_template"
  image_id      = "ami-0aff18ec83b712f05"
  instance_type = "t2.micro"

  user_data = filebase64("${path.module}/user_data.sh")
  vpc_security_group_ids = [aws_security_group.web_traffic.id]
  key_name = "latest"

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_security_group" "web_traffic" {
  name        = "web-traffic"
  description = "Allow SSH and HTTP"

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
