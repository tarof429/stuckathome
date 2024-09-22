variable "server_port" {
  type        = number
  description = "HTTP port of web server"
  default     = 8080
}

variable "ssh_port" {
  type        = number
  description = "SSH port to web server"
  default     = 22
}

variable "ingressrules" {
  type    = list(number)
  default = [22, 8080]
}

variable "egressrules" {
  type    = list(number)
  default = [22, 8080]
}

variable "server_count" {
  type = number
}

variable "image_id" {
  type = string
}