output "alb_dns_name" {
  value       = module.webapp.alb_dns_name
  description = "DNS of the load balancer"
}