variable "container_image" {
  type        = string
  default = "761639968218.dkr.ecr.eu-west-2.amazonaws.com/easy-ecs:latest"
}

variable "domain_name" {
  type = string
  default = "tm.digitalcncloud.org"
}