 # Load balancer + target group + listener

 resource "aws_lb" "main" {
  name               = "easy-ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids

#having teh below as true was giving the following error
#DependencyViolation: Network vpc-08071a7f6ed7887be has some mapped public address(es). Please unmap those public address(es) before detaching the gateway.
  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}


// alb direct traffic to resources - target group
resource "aws_lb_target_group" "app" {
  name        = "alb-target-group"
  vpc_id      = var.vpc_id
  target_type = "ip"
  port        = 3000
  protocol    = "HTTP"

  health_check {
    path                = "/"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 5
  }
}

# changed to https, maybe add http
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06" 
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
