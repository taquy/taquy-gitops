
variable "namespace" {
  description = "Namespace of resources"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}

variable "sg_id" {
  description = "Network interface's security group"
  type        = string
}