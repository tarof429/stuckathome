provider "aws" {
  region = "us-west-2"
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
  name_prefix            = "my_launch_template"
  image_id               = "ami-0aff18ec83b712f05"
  instance_type          = "t2.micro"
  user_data              = filebase64("${path.module}/user_data.sh")
  vpc_security_group_ids = ["sg-0a965d32a1b7f2329"]
  lifecycle {
    create_before_destroy = true
  }
}