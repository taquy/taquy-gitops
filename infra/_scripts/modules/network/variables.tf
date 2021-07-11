
variable "namespace" {
  description = "Namespace of resources"
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR blocks"
  default     = "10.0.0.0/16"
  type        = string
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
}