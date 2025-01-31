resource "aws_alb" "application_load_balancer" {
  name               = "jvs-alb" 
  load_balancer_type = "application"
  subnets = var.subnets
  #  security group
  security_groups = var.security_groups
}

