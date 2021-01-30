output "arn" {
  value = aws_lb.alb.arn
  description = "ARN of the load balancer"
}

output "dns" {
  value = aws_lb.alb.dns_name
  description = "DNS name of the load balancer"
}

output "security_group" {
  value = aws_security_group.alb.id
  description = "ID of the security group attached to the load balancer"
}

output "target_group" {
  value = aws_lb_target_group.alb.arn
  description = "ARN of the target group attached to the load balancer"
}
