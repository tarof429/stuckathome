provider "aws" {
  region = "us-west-2"
}

module "appserver" {
  source        = "./appserver"
  server_ami    = "ami-07d9cf938edb0739b" // Amazon Linux 2023
  instance_type = "t3.medium"
  key_name      = "latest"
}

output "PublicIP" {
  value = module.appserver.gitlab_public_ip
}