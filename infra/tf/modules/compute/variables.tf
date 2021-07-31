
variable "tags" {
  description = "Tags for resources"
  type        = map(string)
}

variable "namespace" {
  description = "Namespace of resources"
  type        = string
}

variable "instance_profile" {
  description = "Instance profile"
  type        = map(string)
}

variable "vm_eni" {
  description = "VM's elastic network interface id"
  type        = string
}

variable "name" {
  description = "Name of ec2 stacks"
  type        = string
}

variable "key_path" {
  description = "Path to ssh public key at local machine"
  type        = string
}

variable "ami" {
  description = "AMI configuration"
  type = object({
    snapshot_id = string
  })
}

variable "instance" {
  description = "Spot instance configuration"
  type = object({
    spot_price = string
    ami        = string
    type       = string
    user_data = optional(object({
      bucket_name = string
      key         = string
    }))
  })
}