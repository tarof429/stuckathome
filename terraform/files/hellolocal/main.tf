terraform {

  required_version = ">= 0.15"
  required_providers {
    local = {
      source  = "hashicorp/local"
    }
  }
}

resource "local_file" "readme" {
  filename = "readme.txt"
  content  = <<-EOT
  Hello local!
  EOT

}
