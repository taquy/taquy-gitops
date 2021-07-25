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

variable "trusted_identities" {
  description = "Trusted principals"
  type        = list(string)
}

variable "source_ip" {
  description = "Source IPs"
  type        = list(string)
}

variable "kms_key_id" {
  description = "KMS key id"
  type        = string
}




