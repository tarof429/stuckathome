output "gitlab_public_ip" {
    value = aws_instance.gitlab_test_server.public_ip
}