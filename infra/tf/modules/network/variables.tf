
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

variable "source_ip" {
  description = "Source IPs"
  default     = ["0.0.0.0/0"]
  type        = list(string)
}

variable "vm_public_ip" {
  description = "VM Public IP"
  default     = ""
  type        = string
}


