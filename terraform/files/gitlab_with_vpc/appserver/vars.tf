variable "server_ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "public_vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "ingressrules" {
  type    = list(number)
  default = [22, 80, 443]
}

variable "egressrules" {
  type    = list(number)
  default = [22, 80, 443]
}
