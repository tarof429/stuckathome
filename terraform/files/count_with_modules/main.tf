provider "aws" {
  region = "us-west-2"
}

module "server" {
  source       = "./server"
  server_names = ["mariadb", "mysql", "mssql"]
  server_ami   = "ami-0604d81f2fd264c7b"
  instance_type = "t2.micro"
}

output "PrivateIP" {
  value = module.server.PrivateIP
}