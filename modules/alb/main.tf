######### ALB #########

resource "aws_lb" "alb" {
  name    = var.alb_name
  subnets = var.public_subnet_ids

  security_groups = [aws_security_group.alb.id]
}

######### ALB LISTENERS #########

resource "aws_lb_listener" "alb" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb.arn
  }
}

######### ALB TARGET GROUP #########

resource "aws_lb_target_group" "alb" {
  # Don't use under_score in name
  name        = "${var.alb_name}-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path     = "/"
    protocol = "HTTP"
    matcher  = "200-299"
  }

  depends_on = [aws_lb.alb]
}

######### ALB Security Group #########

resource "aws_security_group" "alb" {
  name   = "${var.alb_name}_allow_connection"
  vpc_id = var.vpc_id

  ingress {
    description = "Allow http connection on port 80"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
  }

  egress {
    description = "Allow outbound access from the security group"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
