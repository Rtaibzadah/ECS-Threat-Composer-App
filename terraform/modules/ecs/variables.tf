variable "subnets_ids" {
  description = "List of subnet IDs for the ECS service network configuration."
  type        = list(string)
}

variable "sg_ids" {
  description = "List of security group IDs attached to the ECS service ENIs."
  type        = list(string)
}

variable "aws_region" {
  description = "AWS region (required for awslogs logging configuration)."
  type        = string
}

variable "tg_arn" {
  description = "ARN of the ALB target group to register the ECS service with."
  type        = string
}

variable "container_image" {
  description = "Container image URI for the ECS task (e.g., ECR image URI)."
  type        = string
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster."
  type        = string
}

variable "ecs_service_name" {
  description = "Name of the ECS service."
  type        = string
}

variable "ecs_task_name" {
  description = "Name of the container in the task definition (must match service load_balancer.container_name)."
  type        = string
}

variable "log_retention_days" {
  description = "CloudWatch log group retention in days."
  type        = number
  default     = 14
}
