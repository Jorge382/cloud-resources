# Crear el rol IAM para la ejecución de tareas ECS
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole-jvs"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect   = "Allow"
        Sid      = ""
      }
    ]
  })
}

# Crear la política personalizada para acceder a Secrets Manager y otros permisos necesarios
resource "aws_iam_policy" "ecs_full_policy" {
  name        = "ecsFullPolicy-jvs"
  description = "Política para ejecutar tareas ECS, acceder a Secrets Manager, y trabajar con ALB/Target Groups"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Acceso a Secrets Manager
      {
        Effect   = "Allow"
        Action   = "secretsmanager:GetSecretValue"
        Resource = aws_secretsmanager_secret.db_credentials.arn
      },
      # Acceso a CloudWatch Logs
      {
        Effect   = "Allow"
        Action   = "logs:*"
        Resource = "*"
      },
      # Permiso para iniciar sesiones de telemetría de ECS
      {
        Effect   = "Allow"
        Action   = "ecs:StartTelemetrySession"
        Resource = "*"
      },
      # Acceso a ALB/Target Group
      {
        Effect   = "Allow"
        Action   = [
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:DeregisterTargets",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeTargetHealth"
        ]
        Resource = "*"
      },
      # Permisos para ECS interactuar con servicios y tareas
      {
        Effect   = "Allow"
        Action   = [
          "ecs:DescribeServices",
          "ecs:UpdateService",
          "ecs:DescribeTasks"
        ]
        Resource = "*"
      }
    ]
  })
}


# Adjuntar la política al rol IAM
resource "aws_iam_role_policy_attachment" "ecs_task_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_full_policy.arn
}