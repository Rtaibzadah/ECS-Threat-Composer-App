variable "container_image" {
  type        = string
  description = "ECR image URI "
}

variable "domain_name" {
  type = string
  default = "tm.digitalcncloud.org"
}