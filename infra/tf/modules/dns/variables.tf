variable "namespace" {
  description = "Namespace of resources"
  type        = string
}

variable "domain_name" {
  description = "Primary domain name"
  type        = string
}

variable "records" {
  description = "Records to be managed in Route53"
  type = object({
    apps = list(string)
  })
}

variable "tags" {
  description = "Resources tags"
  type        = map(string)
}

variable "vm_public_ip" {
  description = "Elastic public IP of VM"
  type        = string
}