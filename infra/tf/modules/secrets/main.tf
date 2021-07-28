
data "aws_region" "current_region" {}

data "aws_caller_identity" "current_identity" {}

locals {
  region     = data.aws_region.current_region.name
  account_id = data.aws_caller_identity.current_identity.account_id
}

resource "random_string" "random_name" {
  length  = 6
  special = false
  upper   = false
  lower   = true
  number  = false
}

module "label" {
  for_each = var.secrets

  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace = var.namespace
  name      = random_string.random_name.result

  delimiter = "-"

  attributes  = [each.key]
  label_order = ["namespace", "attributes", "name"]

  tags = each.value.tags
}

resource "aws_secretsmanager_secret" "secret" {
  for_each = var.secrets

  name        = module.label[each.key].id
  description = each.value.description
  kms_key_id  = var.kms_key_id
  tags = merge(module.label[each.key].tags, {
    project = var.namespace
  })
}

resource "aws_secretsmanager_secret_version" "secret_version" {
  for_each      = var.secrets
  secret_id     = aws_secretsmanager_secret.secret[each.key].id
  secret_string = lookup(each.value, "data_path", "") != null ? file(each.value.data_path) : (lookup(each.value, "data_value", "") != null ? each.value.data_value : "empty")
}

resource "aws_secretsmanager_secret_policy" "secret_policy" {
  for_each   = var.secrets
  secret_arn = aws_secretsmanager_secret.secret[each.key].arn
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : var.trusted_identities
        },
        "Action" : "secretsmanager:GetSecretValue",
        "Resource" : "arn:aws:secretsmanager:${local.region}:${local.account_id}:secret:*",
        "Condition" : {
          "IpAddress" : {
            "aws:SourceIp" : var.source_ip
          }
        }
      }
    ]
  })
}
