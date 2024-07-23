output "alb_dns_name" {
  value       = aws_lb.lb_example.dns_name
  description = "The domain name of the load balancer"
}

output "target_group_arn" {
  value = aws_lb_target_group.asg.arn
}
