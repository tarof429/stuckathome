provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-taro937184"
    key    = "global/s3/gitlab.tfstate"
    region = "us-west-2"

    dynamodb_table = "gitlab-locks"
    encrypt        = true
  }
}

module "appserver" {
  source        = "./appserver"
  server_ami    = "ami-0604d81f2fd264c7b"
  instance_type = "t2.micro"
  key_name      = "latest"
}

output "PublicIP" {
  value = module.appserver.gitlab_public_ip
}