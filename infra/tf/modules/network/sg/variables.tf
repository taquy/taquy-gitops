
variable "namespace" {
  description = "Namespace of resources"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}

variable "vpc_id" {
  description = "Security group's VPC"
  type        = string
}

variable "source_ip" {
  description = "Source IPs"
  default     = ["0.0.0.0/0"]
  type        = list(string)
}
