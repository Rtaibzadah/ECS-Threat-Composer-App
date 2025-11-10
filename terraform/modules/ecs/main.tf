# ECS cluster + task def + service

resource "aws_cloudwatch_log_group" "ecs" {
  #Log name space that ecs will write too
  name              = "/ecs/easy-ecs"
  retention_in_days = 3
}

resource "aws_ecs_cluster" "ecs-cluster" {
  name = "easy-ecs-cluster"

# enables more insights for cloudwatch
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "service" {
  family                   = "aws-ecs-taskdf"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role1.arn 

# Required for mac users
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

# per container resource config
  container_definitions = jsonencode([
    {
      name         = "aws-ecs-task"
      image        = var.container_image
      cpu          = 256
      memory       = 512
      essential    = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])
}

# Run container using task def and connect to ALB
resource "aws_ecs_service" "aws_ecs_service1" {
  name            = "easy-ecs-service"
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = 1 # Number of tasks
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnets_ids
    security_groups  = var.sg_ids
    assign_public_ip = true # Preferably private subnets + NAT
  }

  # Connect service to lb, ensure that details match
  load_balancer {
    target_group_arn = var.tg_arn
    container_name   = "aws-ecs-task"
    container_port   = 3000
  }
  
}

# IAM Role → gives ECS permission to do its job
# When ECS launches task, it temporarily “assumes” this role to:
# - Pull container image from ECR
# - Write logs to CloudWatch
# - Do setup actions
resource "aws_iam_role" "ecs_task_execution_role1" {
  name = "ecsTaskExecutionRole1"

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
}

# actually gives the role, wihtout the role ECS cant start container
resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role1.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# used in ecs task def - variablised ecr repo and referenced it at the root 
# data "aws_ecr_repository" "name" {
#   name = "easy-ecs"
# }