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

variable "kms_id" {
  description = "CMK to encrypt secrets"
  type        = string
}

variable "trusted_identities" {
  description = "Trusted principals"
  type        = list(string)
}

variable "kms_trusted_identities" {
  description = "Trusted KMS principals"
  type        = map(string)
}

variable "source_ip" {
  description = "Source IPs"
  type        = list(string)
}


