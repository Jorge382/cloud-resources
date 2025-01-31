resource "aws_ecs_service" "my_service" {
  name            = "mi-servicio-secrets-jvs"
  cluster         = aws_ecs_cluster.mi_nombre_ecs.id
  task_definition = aws_ecs_task_definition.my_task_with_secrets.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = var.subnets
    security_groups = var.security_groups
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "wordpress"
    container_port   = 80
  }

}

