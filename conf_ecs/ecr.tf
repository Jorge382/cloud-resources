resource "aws_ecr_repository" "mi_repositorio" {
  name = "mi-repositorio-jvs"
}

resource "aws_ecr_lifecycle_policy" "my_lifecycle_policy" {
  repository = aws_ecr_repository.mi_repositorio.name
  
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Retain images for 30 days and remove older images to manage space efficiently and ensure repository remains within storage limits"
        selection = {
          tagStatus    = "any"
          countType    = "imageCountMoreThan"
          countNumber  = 5
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

