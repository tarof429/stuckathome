provider "aws" {
  region = "us-west-2"
}

module "webapp" {
  source       = "./webapp"
  server_count = var.server_count
  image_id     = var.image_id
}