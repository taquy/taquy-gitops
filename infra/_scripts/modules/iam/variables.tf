variable "namespace" {
  description = "Namespace of resources"
  type        = string
}

variable "tags" {
  description = "Resources tags"
  type        = map(string)
}

variable "source_ip" {
  description = "Source IPs"
  type        = list(string)
}
