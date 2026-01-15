variable "alb_name" {
  type        = string
  description = "ALB name (meaningful, prod-style)."
}

variable "target_group_name" {
  type        = string
  description = "Target group name."
}

variable "http_listener_name" {
  type        = string
  description = "Name tag for the HTTP listener."
}

variable "https_listener_name" {
  type        = string
  description = "Name tag for the HTTPS listener."
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "alb_sg_id" {
  type = string
}

variable "certificate_arn" {
  type        = string
  description = "ACM cert ARN (must be in same region as ALB)."
}

variable "ssl_policy" {
  type    = string
  default = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "app_port" {
  type    = number
}

variable "healthcheck_path" {
  type    = string
  default = "/"
}

variable "internal" {
  type    = bool
}

variable "enable_deletion_protection" {
  type    = bool
  default = false
}
