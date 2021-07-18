module "label" {
  for_each = var.secrets

  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace = var.namespace
  name      = each.key

  delimiter = "-"

  label_order = ["namespace", "name"]

  tags = each.value.tags
}

resource "aws_secretsmanager_secret" "secret" {
  for_each = var.secrets

  name        = module.label[each.key].id
  description = each.value.description
  tags = merge(module.label[each.key].tags, {
    project = var.namespace
  })
}

resource "aws_secretsmanager_secret_version" "secret_version" {
  for_each      = var.secrets
  secret_id     = aws_secretsmanager_secret.secret[each.key].id
  secret_string = each.value.data_path != "" ? file(each.value.data_path) : defaults(each.value.data_value, "")
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
        "Resource" : "arn:aws:secretsmanager:ap-southeast-1:397818416365:secret:*",
        "Condition" : {
          "IpAddress" : {
            "aws:SourceIp" : var.source_ip
          }
        }
      }
    ]
  })
}