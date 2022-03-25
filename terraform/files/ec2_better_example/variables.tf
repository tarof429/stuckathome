variable "instance_tag" {
  description = "Instance tag"
  type        = string
  default     = "devops-vm01"
}

variable "key_name" {
  description = "Name of key pair"
  type        = string
  default     = "mykeypair"
}