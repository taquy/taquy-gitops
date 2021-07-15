
variable "namespace" {
  description = "Namespace of resources"
  type        = string
}

variable "source_ip" {
  description = "Source IPs"
  type        = list(string)
}

variable "roles" {
  description = "policies's role name"
  type        = map(string)
}