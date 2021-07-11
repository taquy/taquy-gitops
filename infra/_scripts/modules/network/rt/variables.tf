
variable "namespace" {
  description = "Namespace of resources"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}

variable "vpc_id" {
  description = "Route tables's VPC"
  type        = string
}

variable "private_subnet_1a" {
  type        = string
  description = "Private subnet AZ #1"
}
variable "private_subnet_2b" {
  type        = string
  description = "Private subnet AZ #2"
}

variable "public_subnet_1a" {
  type        = string
  description = "Public subnet AZ #1"
}
variable "public_subnet_2b" {
  type        = string
  description = "Public subnet AZ #2"
}
