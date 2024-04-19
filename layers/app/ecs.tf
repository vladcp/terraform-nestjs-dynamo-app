######## ECS ########  
resource "aws_ecs_cluster" "app_cluster" {
  name = "nestjs-app-cluster"
  setting {
    name = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_service" "nestjs_app" {
  name = "nestjs-app-service"
  cluster = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.nestjs_app.arn
  launch_type = "FARGATE"
  desired_count = 1 
  
  enable_execute_command = true # for troubleshooting
  force_new_deployment = var.deploy

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name = aws_ecs_task_definition.nestjs_app.family 
    container_port = var.nestjs_container_port
  }

  network_configuration {
    subnets = [aws_default_subnet.default_subnet_a.id, aws_default_subnet.default_subnet_b.id]
    assign_public_ip = true
    security_groups = [aws_security_group.service_security_group.id]
  }

  triggers = {
    redeployment = data.docker_registry_image.app_image.sha256_digest
  }
}

data "docker_registry_image" "app_image" {
  name = var.app_docker_image
}

resource "docker_image" "app_image" {
  name = data.docker_registry_image.app_image.name
  pull_triggers = [data.docker_registry_image.app_image.sha256_digest]
  keep_locally  = false
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "ecs_log_group"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "nestjs_app" {
  family = "nestjs_app_task"
  container_definitions = jsonencode([{
    name = "nestjs_app_task"
    image = "docker.io/vladcp/nestjs-app:latest"
    essential = true
    portMappings = [
      {
        containerPort = var.nestjs_container_port
        hostPort      = var.nestjs_container_port
        protocol = "tcp"
      }
    ]
    logConfiguration: {
      logDriver = "awslogs"
      options   = {
        "awslogs-group"         = "${aws_cloudwatch_log_group.ecs_log_group.name}"
        "awslogs-region"        = "${var.aws_region}"
        "awslogs-stream-prefix" = "ecs"
      }
    }
    memory = 512
    cpu = 256,
    environment: [
      {name: "NODE_ENV", value: var.environment },
      {name: "TABLE_NAME", value: "${aws_dynamodb_table.books_table.id}"}
    ]
  }])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture = "X86_64"
  }

  cpu = 256
  memory = 512
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn = aws_iam_role.ecs_task_execution_role.arn
}