# ECS: cluster + task def + service + logs + IAM exec role

resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/easy-ecs"
  retention_in_days = var.log_retention_days

  tags = {
    Name = "easy-ecs"
  }
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.ecs_cluster_name
  #easy-ecs-cluster
  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "easy-ecs-cluster"
  }
}

resource "aws_ecs_task_definition" "service" {
  family                   = "aws-ecs-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role1.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role1.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

  container_definitions = jsonencode([
    {
      name      = var.ecs_task_name
      image     = var.container_image
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 3000
          # hostPort      = 3000 not needed for Fargate
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }

    }
  ])

  tags = {
    Name = "easy-ecs-task"
  }
}

resource "aws_ecs_service" "aws_ecs_service1" {
  name            = var.ecs_service_name 
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  enable_execute_command             = true
  health_check_grace_period_seconds  = 60
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200


  network_configuration {
    subnets          = var.subnets_ids
    security_groups  = var.sg_ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.tg_arn
    container_name   = var.ecs_task_name
    #"aws-ecs-task"
    container_port = 3000
  }

  tags = {
    Name = "easy-ecs-service"
  }
}

resource "aws_iam_role" "ecs_task_execution_role1" {
  name        = "easy-ecs-exec-role"
  description = "ECS task execution role for easy-ecs"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "easy-ecs-exec-role"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role1.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

