# Declaración del cluster ECS
resource "aws_ecs_cluster" "mi_nombre_ecs" {
  name = "${var.environment}-cluster-jvs"

  setting {
    name  = "containerInsights"
    value = var.container_insight_status
  }

  tags = {
    Environment = var.environment
    Team        = "Devops-bootcamp"
  }
}


