resource "aws_ssm_parameter" "api_key" {
  name  = "/myapp/api_key"
  type  = "SecureString"
  value = "valor de la api key"
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name = "db_credentials-jvs"
}

resource "aws_secretsmanager_secret_version" "db_credentials_value" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = "admin"
    password = "password123"
  })
}

resource "aws_ecs_task_definition" "my_task_with_secrets" {
  family                   = "mi-tarea-secrets"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([{
    name      = "web-serverapp"
    image     = "nginx"
    essential = true
    environment = [
      {
        name  = "API_KEY"
        valueFrom = aws_ssm_parameter.api_key.arn
      }
    ]
    secrets = [
      {
        name      = "DB_CREDENTIALS"
        valueFrom = aws_secretsmanager_secret.db_credentials.arn
      }
    ]
  }])
}
