resource "aws_ssm_parameter" "api_key" {
  name  = "/myapp/api_key_jvs"
  type  = "SecureString"
  value = "valor de la api key"
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name = "db_credentials-jvs-2"
}

resource "aws_secretsmanager_secret_version" "db_credentials_value" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = "admin"
    password = "password123"
  })
}

resource "aws_ecs_task_definition" "my_task_with_secrets" {
  family                   = "wordpress-task-family"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "wordpress"  # Corrección en el nombre del contenedor
    image     = "wordpress:latest"  # Imagen oficial de WordPress
    essential = true
    environment = [
      {
        name  = "WORDPRESS_DB_HOST"
        value = var.rds_endpoint  # El endpoint de tu base de datos RDS
      },
      {
        name  = "WORDPRESS_DB_NAME"
        value = var.db_name
      }
    ]
    secrets = [
      {
        name      = "WORDPRESS_DB_USERNAME"
        valueFrom = "${aws_secretsmanager_secret.db_credentials.arn}:username::"
      },
      {
        name      = "WORDPRESS_DB_PASSWORD"
        valueFrom = "${aws_secretsmanager_secret.db_credentials.arn}:password::"
      }
    ]
    portMappings = [
      {
        containerPort = 80
        hostPort      = 80
        protocol      = "tcp"
      }
    ]
  }])
}


