
variable "namespace" {
  description = "Namespace of resources"
  type        = string
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
variable "ec2" {
  description = "EC2 module parameters"
  type = object({
    name = string
    namespace = string
    key_path = string
    instance = object({
      spot_price = string
      ami = string
      type = string
      user_data = optional(string)
    })
  })
}
