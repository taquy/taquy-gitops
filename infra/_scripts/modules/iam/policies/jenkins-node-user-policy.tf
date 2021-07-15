data "aws_region" "current_region" {

}

data "aws_caller_identity" "current_identity" {
  
}

locals {
  region = data.aws_region.current_region.name
  account_id = data.aws_caller_identity.current_identity.account_id
}

locals {
  role_name = var.users.jenkins_node_user.name
  source_ip = var.source_ip
  statements = {
    "${var.namespace}AssumeRole" = {
      actions = [
        "sts:AssumeRole",
      ],
      resources = [
        var.roles.jenkins_job_role.arn,
      ]
    },
    "${var.namespace}GetSessionToken" = {
      actions = [
        "sts:GetSessionToken",
        "sts:GetCallerIdentity"
      ],
      resources = "*"
    },
  }
}

resource "aws_iam_policy" "policy" {
  name        = local.role_name
  path        = "/"
  description = "Jenkins node policy for ${local.role_name}"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : flatten([
      for sid, statement in local.statements : [
        {
          "Sid" : sid,
          "Effect" : "Allow",
          "Action" : statement.actions,
          "Resource" : statement.resources,
          "Condition" : {
            "IpAddress" : {
              "aws:SourceIp" : var.source_ip
            }
          }
        }
      ]
    ])
  })
}

resource "aws_iam_policy_attachment" "policy_attachment" {
  name       = local.role_name
  users      = [var.users.jenkins_node_user.name]
  roles      = []
  groups     = []
  policy_arn = aws_iam_policy.policy.arn
}