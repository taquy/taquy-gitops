

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
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace   = var.namespace
  delimiter   = "-"
  label_order = ["namespace"]
  tags        = var.tags
}

resource "aws_kms_key" "kms" {
  description             = "KMS key 1"
  key_usage               = "ENCRYPT_DECRYPT"
  deletion_window_in_days = 7
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "key-consolepolicy-3",
    "Statement" : [
      {
        "Sid" : "Enable IAM User Permissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : concat(["arn:aws:iam::${local.account_id}:root"], var.key_admins)
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },
      {
        "Sid" : "Allow use of the key",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : var.key_users
        },
        "Action" : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        "Resource" : "*"
      }
    ]
  })
  tags = merge(module.label.tags, {
    project = var.namespace
  })
}

resource "aws_kms_alias" "kms_alias" {
  name          = "alias/taquy-secret-manager-${random_string.random_name.result}"
  target_key_id = aws_kms_key.kms.key_id
}