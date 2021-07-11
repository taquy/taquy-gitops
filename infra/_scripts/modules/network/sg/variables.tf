
variable "namespace" {
  description = "Namespace of resources"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = string
}

variable "vpc_id" {
  description = "Security group's VPC"
  type        = string
}