data "aws_region" "current_region" {

}

data "aws_caller_identity" "current_identity" {
  
}

locals {
  region = data.aws_region.current_region.name
  account_id = data.aws_caller_identity.current_identity.account_id
}

locals {
  source_ip = var.source_ip
  statements = {
    "${var.namespace}EcrPushImages" = {
      actions = [
        "ecr:DescribeImageScanFindings",
        "ecr:GetLifecyclePolicyPreview",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:DescribeImages",
        "ecr:DescribeRepositories",
        "ecr:ListTagsForResource",
        "ecr:ListImages",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetRepositoryPolicy",
        "ecr:GetLifecyclePolicy"
      ],
      resources = [
        "arn:aws:ecr:${local.region}:${local.account_id}:repository/*",
      ]
    },
    "${var.namespace}EcrAuthentication" = {
      actions = [
        "ecr:GetRegistryPolicy",
        "ecr:DescribeRegistry",
        "ecr:GetAuthorizationToken"
      ],
      resources = "*"
    },
    "${var.namespace}CwLogs" = {
      actions = [
        "logs:CreateLogStream",
        "logs:DescribeLogStreams",
        "logs:CreateLogGroup"
      ],
      resources = "arn:aws:logs:${local.region}:${local.account_id}:log-group:*"
    },
    "${var.namespace}PutLogs" = {
      actions   = "logs:PutLogEvents",
      resources = "arn:aws:logs:${local.region}:${local.account_id}:log-group:*:log-stream:*"
    },
    "${var.namespace}S3GetDeployObjects" = {
      actions   = "s3:GetObject",
      resources = "arn:aws:s3:::taquy-deploy/*"
    },
    "${var.namespace}S3ListBuckets" = {
      actions = [
        "s3:ListBucket",
        "s3:ListAllMyBuckets"
      ],
      resources = "*"
    },
    "${var.namespace}S3UpdateObjects" = {
      actions = [
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:PutObjectAcl"
      ],
      resources = [
        "arn:aws:s3:::taquy-master/*",
        "arn:aws:s3:::taquy-backup/*"
      ]
    }
  }
}

resource "aws_iam_policy" "policy" {
  name        = var.roles.instance_role_name
  path        = "/"
  description = "Instance policy for ${var.roles.instance_role_name}"
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
  name       = var.roles.instance_role_name
  users      = []
  roles      = [var.roles.instance_role_name]
  groups     = []
  policy_arn = aws_iam_policy.policy.arn
}