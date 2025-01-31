resource "aws_cloudwatch_metric_alarm" "cpu_alarm_high" {
  alarm_name          = "HighCPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300  # 5 minutos
  statistic           = "Average"
  threshold           = 80  # 80% de CPU
  alarm_description   = "This metric triggers when the CPU utilization is above 80% for 5 minutes."
  dimensions = {
    ClusterName = aws_ecs_cluster.mi_nombre_ecs.name
    ServiceName = aws_ecs_service.my_service.name
  }
}