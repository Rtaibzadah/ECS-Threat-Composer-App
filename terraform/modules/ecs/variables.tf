variable "subnets_ids" {
  type = list(string)
}

variable "sg_ids" {
  type = list(string)
}

variable "aws_region" {
  type = string
}

variable "tg_arn" {
  type = string
}

variable "container_image" {
  type        = string
  description = "ECR image for ECS task"
}
