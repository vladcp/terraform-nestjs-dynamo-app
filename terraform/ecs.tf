data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

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
  
  enable_execute_command = false # for troubleshooting
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
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "ecs_log_group"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "nestjs_app" {
  family = "nestjs_app_task"
  container_definitions = jsonencode([{
    name = "nestjs-app"
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
        "awslogs-region"        = "$`{var.aws_region}"
        "awslogs-stream-prefix" = "ecs"
      }
    }
    memory = 512
    cpu = 256
  }])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture = "ARM64"
  }
  cpu = 256
  memory = 512
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  execution_role_arn = data.aws_iam_role.ecs_task_execution_role.arn
  task_role_arn = data.aws_iam_role.ecs_task_execution_role.arn
}

###### NETWORKING VPC ########
# Provide a reference to your default VPC
resource "aws_default_vpc" "default_vpc" {
}

resource "aws_default_subnet" "default_subnet_a" {
  availability_zone = "eu-west-2a"
}
resource "aws_default_subnet" "default_subnet_b" {
  # Use your own region here but reference to subnet 1b
  availability_zone = "eu-west-2b"
}

######### ALB #######
resource "aws_alb" "application_load_balancer" {
  name               = "load-balancer-nestjs-app" #load balancer name
  load_balancer_type = "application"
  subnets = [ # Referencing the default subnets
    aws_default_subnet.default_subnet_a.id,
    aws_default_subnet.default_subnet_b.id
  ]
  # security group
  security_groups = [aws_security_group.load_balancer_security_group.id]
}

resource "aws_security_group" "load_balancer_security_group" {
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic in from all sources
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "service_security_group" {
  ingress {
    from_port = var.nestjs_container_port
    to_port   = var.nestjs_container_port
    protocol  = "tcp"
    # Only allowing traffic in from the load balancer security group
    security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "target_group" {
  name        = "target-group"
  port        = var.nestjs_container_port # or 3000?
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_default_vpc.default_vpc.id # default VPC
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 60
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 30
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.application_load_balancer.arn #  load balancer
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn # target group
  }
}

output "app_url" {
  value = aws_alb.application_load_balancer.dns_name
}