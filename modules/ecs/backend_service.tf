locals {
  backend_name  = "backend"
  backend_image = "traefik/whoami"
}

resource "aws_ecs_task_definition" "backend" {
  family             = "${var.cluster_name}-${local.backend_name}"
  execution_role_arn = aws_iam_role.task_execution_role.arn
  task_role_arn      = aws_iam_role.proxy.arn

  container_definitions = templatefile("${path.module}/task-definitions/${local.backend_name}.json.tpl", {
    service_name = local.backend_name,
    image_url    = local.backend_image
    cluster_name = var.cluster_name
    alb_dns      = var.alb_dns
    region       = "us-east-1"
  })

  cpu                      = 256
  memory                   = 512
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
}

resource "aws_ecs_service" "backend" {
  name            = local.backend_name
  launch_type     = "FARGATE"
  # propagate_tags  = "SERVICE"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = 1

  network_configuration {
    assign_public_ip = false
    security_groups  = [aws_security_group.proxy_service.id]
    subnets          = var.private_subnet_ids
  }
}

resource "aws_security_group" "backend_service" {
  name   = "${var.cluster_name}-${local.backend_name}"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "TCP"
    security_groups = [aws_security_group.proxy_service.id]
  }
}
