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

#  Wont use access logs for now
#   access_logs {
#     bucket  = aws_s3_bucket.lb_logs.id
#     prefix  = "test-lb"
#     enabled = true
#   }

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


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"
  # ssl_policy = "ELBSecurityPolicy-2016-08" # only needed for HTTPS

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
