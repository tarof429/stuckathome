output "alb_dns_name" {
  value       = aws_lb.mylb.dns_name
  description = "DNS of the load balancer"
}