module "vpc" {
  source   = "./modules/vpc"
  project  = "easy-ecs"
  vpc_cidr = "10.0.0.0/16"
}

module "sg" {
  source   = "./modules/sg"
  vpc_id   = module.vpc.vpc_id
  vpc_cidr = "10.0.0.0/16"
}

module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id = module.sg.alb_sg_id
  certificate_arn = module.acm.certificate_arn
}

module "ecs" {
  source      = "./modules/ecs"
  subnets_ids = module.vpc.public_subnet_ids
  sg_ids      = [module.sg.svc_sg_id]
  aws_region  = "eu-west-2"
  tg_arn      = module.alb.tg_arn
  container_image = var.container_image

}
module "route53" {
  source = "./modules/route53"
  alb_dns_name = module.alb.lb_dns_name
  alb_zone_id = module.alb.lb_zone_id
  domain_name = var.domain_name
}

module "acm" {
  source = "./modules/acm"
  domain_name = var.domain_name
  hosted_zone_id = module.route53.route53_hosted_zone
}
# hello my name