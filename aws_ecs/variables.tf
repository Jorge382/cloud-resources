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