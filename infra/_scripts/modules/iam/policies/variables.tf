
variable "namespace" {
  description = "Namespace of resources"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}

variable "source_ip" {
  description = "Source IPs"
  type        = list(string)
}

variable "vm_role" {
  description = "VM's role"
  type        = string
}