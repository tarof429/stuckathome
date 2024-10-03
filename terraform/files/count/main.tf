provider "aws" {
  region = "us-west-2"
}

variable "server_names" {
  type    = list(string)
  default = ["mariadb", "mysql", "mssql"]
}

resource "aws_instance" "server" {
  ami           = "ami-0604d81f2fd264c7b"
  instance_type = "t2.micro"
  count         = length(var.server_names)

  tags = {
    Name = var.server_names[count.index]
  }
}

output "PrivateIP" {
  value = [aws_instance.server.*.private_ip]
}