variable "ami" {
  type    = string
  default = "ami-07d9cf938edb0739b" // Amazon Linux 2023
}

variable "instance_type" {
  type    = string
  default = "t2.medium" // 2 vCPU 4GiB Memory
}

variable "ingressrules" {
  type    = list(number)
  default = [22, 80, 8443]
}
