variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC."
}

variable "project" {
  type        = string
  description = "Project name (kept for interface consistency even if tags/names are hard-coded)."
}