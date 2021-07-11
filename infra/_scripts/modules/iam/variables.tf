variable "namespace" {
  description = "Namespace of resources"
  type        = string
}

variable "name" {
  description = "Name of ec2 stacks"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = string
}

variable "source_ip" {
  description = "Source IPs"
  type        = string
}
