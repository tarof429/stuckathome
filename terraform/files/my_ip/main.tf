provider "aws" {
  region = "us-west-2"
}

data "http" "myip" {
  url = "https://ifconfig.me"
}

output "my_public_ip" {
    value = data.http.myip.response_body
}