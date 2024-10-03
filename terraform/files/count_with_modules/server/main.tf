resource "aws_instance" "server" {
  ami           = var.server_ami
  instance_type = var.instance_type
  count         = length(var.server_names)

  tags = {
    Name = var.server_names[count.index]
  }
}

output "PrivateIP" {
  value = [aws_instance.server.*.private_ip]
}