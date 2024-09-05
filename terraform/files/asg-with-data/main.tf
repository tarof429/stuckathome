provider "aws" {
  region = "us-west-2"
}

resource "aws_autoscaling_group" "example" {
  availability_zones = ["us-west-2a", "us-west-2b"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = aws_launch_template.my_launch_template.id
    version = "$Latest"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  # Amazon
  owners = ["099720109477"]
}

data "aws_vpc" "default" {
  default = true
}

data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id

  filter {
    name   = "group-name"
    values = ["default"]
  }
}

resource "aws_launch_template" "my_launch_template" {
  name_prefix = "my_launch_template"
  image_id    = data.aws_ami.ubuntu.image_id
  instance_type = "t2.micro"
  user_data     = filebase64("${path.module}/user_data.sh")
  vpc_security_group_ids = [data.aws_security_group.default.id]
  lifecycle {
    create_before_destroy = true
  }
}