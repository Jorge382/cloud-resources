# Declaración de variables

variable "instance_type" {
  description = "Tipo de la instancia EC2"
  type        = string
  #default     = "c5.large"  # Valor por defecto para el tipo de instancia
}

# variables.tf
variable "tag_value" {
  description = "El valor del tag para el recurso"
  type        = string
}


variable "module_path" {
  type        = string
}


variable "vpc_id" {

  type        = string
}

variable "subnets" {

  type        = list
}
