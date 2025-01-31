variable "repository_name" {
  description = "The name of the ECR repository"
  type        = string
}

variable "policy_document" {
  description = "The JSON policy document for the ECR repository"
  type        = string
}
