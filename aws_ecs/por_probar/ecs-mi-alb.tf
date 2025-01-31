resource "aws_lb" "ejemplo-alb" {
  name               = "ecs-alb-jvs"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.default.id]
  subnets            = [aws_subnet.default.id]
}

resource "aws_lb_target_group" "ecs_targets" {
  name     = "ecs-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.default.id
}

resource "aws_ecs_service" "nginx_service" {
  name            = "nginx-service"
  cluster         = aws_ecs_cluster.mi_nombre_ecs.id
  task_definition = aws_ecs_task_definition.nginx_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  
  network_configuration {
    subnets         = [aws_subnet.default.id]
    security_groups = [aws_security_group.default.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_targets.arn
    container_name   = "nginx"
    container_port   = 80
  }
}
