terraform {
  required_version = ">= 0.14.8"
  experiments      = [module_variable_optional_attrs]
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 2.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 1.3"
    }
  }
}