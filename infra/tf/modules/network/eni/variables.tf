
variable "namespace" {
  description = "Namespace of resources"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}

variable "vm_sg_id" {
  description = "Network interface's security group for VM"
  type        = string
}
variable "vm_subnet_id" {
  description = "Network interface's subnet for VM"
  type        = string
}