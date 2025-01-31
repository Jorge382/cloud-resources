resource "aws_appautoscaling_target" "ecs_scaling_target" {
  max_capacity = 10
  min_capacity = 1
  resource_id = "service/${aws_ecs_cluster.mi_nombre_ecs.name}/${aws_ecs_service.my_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
  depends_on = [aws_ecs_service.my_service]
}


resource "aws_appautoscaling_policy" "ecs_scaling_policy" {
  name = "scale-out"
  policy_type = "StepScaling"
  resource_id = aws_appautoscaling_target.ecs_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_scaling_target.scalable_dimension
  service_namespace = aws_appautoscaling_target.ecs_scaling_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type = "ChangeInCapacity"
    cooldown         = 300
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment = 1
    }
  }
}

