output "gitlab_public_ip" {
  value = aws_eip.gitlab_appserver_eip.public_ip
}