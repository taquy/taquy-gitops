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
  tags        = module.label[each.key].tags
}

resource "aws_secretsmanager_secret_version" "secret_version" {
  for_each      = var.secrets
  secret_id     = aws_secretsmanager_secret.secret[each.key].id
  secret_string = each.value.data_path != "" ? file(each.value.data_path) : defaults(each.value.data_value, "")
}

resource "aws_secretsmanager_secret_policy" "secret_policy" {
  for_each   = var.secrets
  secret_arn = aws_secretsmanager_secret.secret[each.key].arn
  policy     = <<POLICY
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect": "Allow",
          "Principal": {
            "AWS": [
              "arn:aws:iam::397818416365:role/taquy-jenkins",
              "arn:aws:iam::397818416365:user/admin"
            ]
          },
          "Action": "secretsmanager:GetSecretValue",
          "Resource": "arn:aws:secretsmanager:ap-southeast-1:397818416365:secret:*",
           "Condition": {
                "IpAddress": {
                    "aws:SourceIp": [
                      "113.161.105.75",
                      "118.71.244.0/24",
                      "171.229.169.0/24",
                      "1.54.208.0/24"
                    ]
                }
            }
        }
      ]
    }
  POLICY
}
