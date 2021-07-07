provider "aws" {
  region                      = "ap-southeast-1"
  s3_force_path_style         = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
}

terraform {
  backend "s3" {
    bucket     = "taquy-tfstate"
    key        = "jenkins-secrets.tfstate"
    region     = "ap-southeast-1"
    encrypt    = true
    kms_key_id = "arn:aws:kms:ap-southeast-1:397818416365:key/ef84ca25-237c-45bd-8fdd-2bda5a31c547"
  }
  experiments      = [module_variable_optional_attrs]
  required_version = ">= 0.14.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.0"
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