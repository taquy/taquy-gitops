
variable "my_ip" {
  description = "Current deployer source IP"
  type        = string
}

variable "pgp_key" {
  description = "PGP base64 encoded public key"
  type        = string
}

variable "kms" {
  description = "KMS module for encryption"
  type = object({
    namespace  = string
    tags       = optional(map(string))
    key_admins = list(string)
    key_users  = list(string)
  })
}

variable "secrets" {
  description = "Secret manager module parameters"
  type = object({
    namespace = string
    secrets = map(object({
      description = optional(string)
      data_path   = optional(string)
      data_value  = optional(string)
      tags        = optional(map(string))
    }))
  })
}

variable "cw" {
  description = "CloudWatch module parameters"
  type = object({
    namespace = string
    tags      = optional(map(string))
  })
}

variable "network" {
  description = "Network module parameters"
  type = object({
    namespace      = string
    vm_public_ip      = string
    vpc_cidr_block = string
    tags           = optional(map(string))
  })
}

variable "compute" {
  description = "compute module parameters"
  type = object({
    enabled = bool
    name      = string
    namespace = string
    ami = object({
      snapshot_id = string
    })
    region   = string
    key_path = string
    tags     = optional(map(string))
    instance = object({
      spot_price = string
      ami        = string
      type       = string
      user_data = optional(object({
        bucket_name = string
        key         = string
      }))
    })
  })
}

variable "iam" {
  description = "iam module parameters"
  type = object({
    namespace = string
    source_ip = optional(map(string))
    tags      = optional(map(string))
  })
}

variable "dns" {
  description = "dns module parameters"
  type = object({
    namespace   = string
    domain_name = string
    records = object({
      apps = list(string)
    })
    tags = optional(map(string))
  })
}

