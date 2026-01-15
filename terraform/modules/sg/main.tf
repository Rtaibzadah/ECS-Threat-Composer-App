resource "aws_security_group" "alb_sg" {
  name        = "easy-ecs-alb-sg"
  description = "Security group for the Application Load Balancer"
  vpc_id      = var.vpc_id

  tags = {
    Name = "easy-ecs-alb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http_80" {
  description       = "Allow HTTP from internet"
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "alb_https_443" {
  description       = "Allow HTTPS from internet"
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "alb_egress_all" {
  description       = "Allow all outbound traffic"
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "svc_sg" {
  name        = "easy-ecs-service-sg"
  description = "Security group for ECS tasks"
  vpc_id      = var.vpc_id

  tags = {
    Name = "easy-ecs-service-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "svc_from_alb_app_port" {
  description                  = "Allow app traffic from ALB"
  security_group_id            = aws_security_group.svc_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id
  from_port                    = var.app_port
  to_port                      = var.app_port
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "svc_egress_all" {
  description       = "Allow all outbound traffic"
  security_group_id = aws_security_group.svc_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
