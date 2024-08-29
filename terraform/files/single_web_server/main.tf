provider "aws" {
  region = "us-west-2"
}

variable "server_port" {
  type        = number
  description = "HTTP port of web server"
  default     = 8080
}

resource "aws_instance" "single_web_server" {
  ami                    = "ami-0aff18ec83b712f05"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.mysg.id]

  user_data = <<-EOF
        #!/bin/bash
        echo "Hello World!" > index.html
        nohup busybox httpd -f -p ${var.server_port} &
    EOF

  user_data_replace_on_change = true


  tags = {
    Name = "single_web_server"
  }
}

resource "aws_security_group" "mysg" {
  name = "single_web_server_sg"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "web_server" {
  description = "Accesss web server"
  value       = "http://${aws_instance.single_web_server.public_ip}:8080"
}