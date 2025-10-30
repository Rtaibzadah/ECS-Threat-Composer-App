output "alb_sg_id" {
  value       = aws_security_group.alb_sg.id
  description = "Security Group ID for the Application Load Balancer"
}

output "svc_sg_id" {
  value       = aws_security_group.svc.id
  description = "Security Group ID for ECS service tasks"
}