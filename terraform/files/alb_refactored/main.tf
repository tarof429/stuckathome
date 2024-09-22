provider "aws" {
  region = "us-west-2"
}

resource "aws_autoscaling_group" "example" {
  # Specify the AZs that support t2.micro
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
  #vpc_zone_identifier = data.aws_subnets.default_vpc_subnets.ids

  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"

  desired_capacity = 2
  max_size         = 2
  min_size         = 1

  tag {
    key                 = "Name"
    value               = "example-asg"
    propagate_at_launch = true
  }

  launch_template {
    id      = aws_launch_template.my_launch_template.id
    version = "$Latest"
  }
}

resource "aws_launch_template" "my_launch_template" {
  name_prefix   = "my_launch_template"
  image_id      = "ami-0aff18ec83b712f05"
  instance_type = "t2.micro"

  user_data              = filebase64("${path.module}/user_data.sh")
  vpc_security_group_ids = [aws_security_group.web_traffic.id]
  key_name               = "latest"

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

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default_vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_lb" "mylb" {
  name               = "mylb"
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default_vpc_subnets.ids
  security_groups    = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.mylb.arn
  port              = 8080
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_security_group" "alb" {
  name = "alb-security-group"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "asg" {
  name     = "myalb-target-group"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}
