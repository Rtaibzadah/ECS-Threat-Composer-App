module "vpc" {
  source   = "./modules/vpc"
  project  = "easy-ecs"
  vpc_cidr = "10.0.0.0/16"
}

module "sg" {
  source   = "./modules/sg"
  vpc_id   = module.vpc.vpc_id
  app_port = 3000
}


module "alb" {
  source = "./modules/alb"

  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public_subnet_ids
  alb_sg_id           = module.sg.alb_sg_id
  certificate_arn     = module.acm.certificate_arn

  alb_name            = "easy-ecs-app-alb"
  target_group_name   = "easy-ecs-app-tg"
  http_listener_name  = "easy-ecs-http-redirect"
  https_listener_name = "easy-ecs-https-listener"

  app_port         = 3000
  healthcheck_path = "/"
  internal         = false
  enable_deletion_protection = false
}

module "ecs" {
  source             = "./modules/ecs"
  subnets_ids        = module.vpc.public_subnet_ids
  sg_ids             = [module.sg.svc_sg_id]
  aws_region         = "eu-west-2"
  tg_arn             = module.alb.tg_arn
  container_image    = var.container_image
  ecs_cluster_name   = "easy-ecs-cluster"
  ecs_service_name   = "easy-ecs-service"
  ecs_task_name      = "aws-ecs-task"
  log_retention_days = 14
}

module "route53" {
  source       = "./modules/route53"
  alb_dns_name = module.alb.lb_dns_name
  alb_zone_id  = module.alb.lb_zone_id
  domain_name  = var.domain_name
}

module "acm" {
  source         = "./modules/acm"
  domain_name    = var.domain_name
  hosted_zone_id = module.route53.route53_hosted_zone
}
