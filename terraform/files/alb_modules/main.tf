provider "aws" {
  region = "us-west-2"
}

module "webapp" {
    source = "./webapp"
}