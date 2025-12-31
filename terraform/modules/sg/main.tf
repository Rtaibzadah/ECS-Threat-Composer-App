# Traffic going to the lb
resource "aws_security_group" "alb_sg" {
  name        = "easy-ecs-alb-sg"
  vpc_id      = var.vpc_id

  tags = {
    Name      = "easy-ecs-alb-sg"
  }
}

# ALB allows inbound HTTP 
resource "aws_vpc_security_group_ingress_rule" "alb_http_80" {
  description       = "SG, Allow HTTP to ALB"
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}
# ALB allows inbound HTTPS
resource "aws_vpc_security_group_ingress_rule" "alb_https_443" {
  description       = "SG, Allow HTTPS to ALB"
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

# ALB allows all outbound traffic
resource "aws_vpc_security_group_egress_rule" "alb_egress_all" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}


# Only Allow traffic from ALB to ECS Service
resource "aws_security_group" "svc" {
  name        = "svc"
  vpc_id      = var.vpc_id
  description = "SG, ECS service tasks"

  tags = {
    Name      = "easy-ecs-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "svc_from_alb_3000" {
  description       = "Allow ALB tasks on app port"
  security_group_id = aws_security_group.svc.id
  # allow traffic only from the ALB
  referenced_security_group_id = aws_security_group.alb_sg.id
  from_port         = 3000
  to_port           = 3000
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "svc_egress_all" {
  description       = "Allow tasks to external services"
  security_group_id = aws_security_group.svc.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}