resource "aws_ecs_task_definition" "nginx_task" {
  family                   = "nginx-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"  # Definimos la CPU a nivel de tarea
  memory                   = "512"  # Definimos la memoria a nivel de tarea
  container_definitions    = jsonencode([
    {
      name        = "nginx-container"
      image       = "nginx:latest"
      cpu         = 256
      memory      = 512
      essential   = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

