terraform {

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = "tf-user"
  region  = "us-west-2"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0d70546e43a941d70"
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}
