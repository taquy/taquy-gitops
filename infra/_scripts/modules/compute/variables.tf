
variable "tags" {
  description = "Tags for resources"
  type        = map(string)
}

variable "namespace" {
  description = "Namespace of resources"
  type        = string
}

variable "name" {
  description = "Name of ec2 stacks"
  type        = string
}

variable "vpc_id" {
  description = "EC2 VPC ID"
  type        = string
}

variable "subnet_id" {
  description = "EC2 Subnet ID"
  type        = string
}

variable "key_path" {
  description = "Path to ssh public key at local machine"
  type        = string
}

variable "instance" {
  description = "Spot instance configuration"
  type = object({
    spot_price = string
    ami        = string
    type       = string
    user_data  = optional(string)
  })
}