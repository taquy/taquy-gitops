
variable "namespace" {
  description = "Namespace of resources"
  type        = string
}

variable "source_ip" {
  description = "Source IPs"
  type        = list(string)
}

variable "identities" {
  description = "policies's role name"
  type        = any
}