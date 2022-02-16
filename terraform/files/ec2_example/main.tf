terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_instance" "app_server" {
  #ami           = "ami-0892d3c7ee96c0bf7"
  ami           = "ami-074251216af698218"
  instance_type = "t2.micro"

  tags = {
    Name = "my-instance"
  }
}
