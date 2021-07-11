
variable my_ip {
  description 
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

variable "network" {
  description = "Network module parameters"
  type = object({
    namespace      = string
    vpc_cidr_block = string
    tags           = optional(map(string))
  })
}

variable "compute" {
  description = "compute module parameters"
  type = object({
    name      = string
    namespace = string
    region    = string
    key_path  = string
    tags      = optional(map(string))
    instance = object({
      spot_price = string
      ami        = string
      type       = string
      user_data  = optional(string)
    })
  })
}

variable "iam" {
  description = "iam module parameters"
  type = object({
    namespace      = string
    source_ip      = optional(map(string))
    tags           = optional(map(string))
  })
}

