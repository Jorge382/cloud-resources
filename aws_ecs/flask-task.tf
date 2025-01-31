resource "aws_ecs_task_definition" "flask_task" {
  family                   = "flask-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512" # Incrementar CPU
  memory                   = "1024" # Incrementar memoria
  container_definitions    = jsonencode([
    {
      name        = "flask-container"
      image       = "tiangolo/uwsgi-nginx-flask"
      cpu         = 512
      memory      = 1024
      essential   = true
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
        }
      ]
    }
  ])
}



