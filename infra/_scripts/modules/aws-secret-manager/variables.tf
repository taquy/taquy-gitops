variable "secrets" {
  description = "List of secrets"
  type = map(object({
    description = optional(string)
    data_path   = optional(string)
    data_value  = optional(string)
    tags        = optional(map(string))
  }))
}

variable "namespace" {
  description = "Namespace of resources"
  type        = string
}