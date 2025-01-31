variable "environment" {
  description = "The environment name"
  type        = string
}

variable "container_insight_status" {
  description = "Status of container insights (e.g., enable or disable)"
  type        = string
}

variable "aws_region" {
  description = "La región de AWS donde se desplegarán los recursos"
  type        = string
  #default     = "eu-west-3"  # Valor por defecto para la región (París)
}

variable "vpc_id" {
  description = "Id de VPC"
  type        = string

}

variable "subnets" {

  type        = list
}

variable "security_groups" {
  type = list(string)
}

variable "rds_endpoint" {
  description = "El endpoint de la base de datos RDS"
  type        = string
}

variable "db_name" {
  description = "El nombre de la base de datos"
  type        = string
}