output "lb_dns_name" {
  description = "Public DNS name of the ALB"
  value       = aws_lb.main.dns_name
}

output "lb_zone_id" {
  description = "Hosted zone ID of the ALB"
  value       = aws_lb.main.zone_id
}



output "lb_arn" {
  description = "ARN of the ALB"
  value       = aws_lb.main.arn
}

# the ones above gpt made
output "tg_arn" {
  description = "ARN of the target group that ECS should register to"
  value       = aws_lb_target_group.app.arn
}