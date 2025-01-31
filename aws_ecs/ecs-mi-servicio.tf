resource "aws_security_group" "rds_security_group" {
  name        = "jvs-rds-high-availability"
  description = "Security group para RDS Multi-AZ"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jvs-security-group-ecs"
  }
}

resource "aws_lb" "ejemplo-alb" {
  name               = "ecs-alb-jvs"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.rds_security_group.id]
  subnets            = var.subnets

  enable_deletion_protection = false

  tags = {
    Name = "nginx-load-balancer-jvs"
  }
}

resource "aws_lb_target_group" "web_targets" {
  name        = "web-target-group-jvs"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }

  depends_on = [aws_lb.ejemplo-alb]

  tags = {
    Name = "web-target-group-jvs"
  }
}

resource "aws_lb_target_group" "api_targets" {
  name        = "api-target-group-jvs"
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }

  depends_on = [aws_lb.ejemplo-alb]

  tags = {
    Name = "api-target-group-jvs"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.ejemplo-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "web_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_targets.arn
  }

  condition {
    path_pattern {
      values = ["/web*"]
    }
  }
}

resource "aws_lb_listener_rule" "api_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 101

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_targets.arn
  }

  condition {
    path_pattern {
      values = ["/api*"]
    }
  }
}

resource "aws_ecs_service" "nginx_service" {
  name            = "nginx-service"
  cluster         = aws_ecs_cluster.mi_nombre_ecs.id
  task_definition = aws_ecs_task_definition.nginx_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnets
    security_groups = [aws_security_group.rds_security_group.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.web_targets.arn
    container_name   = "nginx-container"
    container_port   = 80
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  tags = {
    Name = "nginx-service-jvs"
  }

  depends_on = [aws_lb_listener_rule.web_rule]
}
