
variable "vpc_id" {
  description = "VPC ID where security groups will be created."
  type        = string
}

variable "app_port" {
  description = "Port the ECS service listens on."
  type        = number
}

