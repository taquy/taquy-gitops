
variable "namespace" {
  description = "Namespace of resources"
  type        = string
}

variable "name" {
  description = "Name of resources"
  type        = string
}

variable "source_ip" {
  description = "Source IPs"
  type        = list(string)
}

variable "vm_role" {
  description = "VM's role"
  type        = string
}