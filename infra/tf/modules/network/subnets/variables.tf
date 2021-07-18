
variable "namespace" {
  description = "Namespace of resources"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}

variable "vpc_id" {
  description = "Subnets's VPC"
  type        = string
}
variable "vpc_cidr" {
  description = "Subnets's VPC CIDR block"
  type        = string
}