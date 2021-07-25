output "secret" {
  value = tomap({
    for k, v in var.secrets : k => {
      id  = aws_secretsmanager_secret.secret[k].id
      arn = aws_secretsmanager_secret.secret[k].arn
    }
  })
}

output "secret_version" {
  value = tomap({
    for k, v in var.secrets : k => {
      id         = aws_secretsmanager_secret_version.secret_version[k].id
      arn        = aws_secretsmanager_secret_version.secret_version[k].arn
      version_id = aws_secretsmanager_secret_version.secret_version[k].version_id
    }
  })
}