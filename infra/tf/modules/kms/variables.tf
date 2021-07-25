
variable "namespace" {
  description = "Namespace of resources"
  type        = string
}

variable "key_admins" {
  description = "Key's admin"
  type        = list(string)
}

variable "key_users" {
  description = "Key's users"
  type        = list(string)
}

variable "tags" {
  description = "Resources tags"
  type        = map(string)
}
