resource "aws_ecs_task_definition" "backend" {
  family                   = "${local.name_prefix}-backend"
  requires_compatibilities = ["FARGATE"]

  network_mode = "awsvpc"

  cpu    = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_execution.arn
  task_role_arn      = aws_iam_role.ecs_task.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

  container_definitions = jsonencode([
    {
      name = "backend"

      image = "${aws_ecr_repository.backend.repository_url}:v2"

      essential = true

      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "GCP_PROJECT_ID"
          value = "flawless-window-499104-u9"
        },
        {
          name  = "BQ_DATASET_ID"
          value = "ema_dev_events"
        },
        {
          name  = "BQ_TABLE_ID"
          value = "raw_events"
        },
        {
          name  = "GCP_SERVICE_ACCOUNT_JSON"
          value = var.gcp_service_account_json
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.backend.name
          awslogs-region        = "eu-north-1"
          awslogs-stream-prefix = "backend"
        }
      }
    }
  ])

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-backend-task"
      Tier = "application"
    }
  )
}