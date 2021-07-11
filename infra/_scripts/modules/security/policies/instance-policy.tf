
module "label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace   = var.namespace
  name        = var.name
  delimiter   = "-"
  label_order = ["namespace", "name"]
  tags        = var.tags
}

module "roles" {
  source = "../roles"
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
        "arn:aws:ecr:${var.region}:${var.account_id}:repository/*",
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
      resources = "arn:aws:logs:${var.region}:${var.account_id}:log-group:*"
    },
     "${var.namespace}PutLogs" = {
      actions = "logs:PutLogEvents",
      resources = "arn:aws:logs:${var.region}:${var.account_id}:log-group:*:log-stream:*"
    },
     "${var.namespace}S3GetDeployObjects" = {
      actions = "s3:GetObject",
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
  depends_on = [
    module.roles.aws_iam_role.instance_role,
  ]
  name        = "${var.namespace}-vm"
  path        = "/"
  description = "Instance policy for ${var.namespace}-vm"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : flatten([
      for sid, statement in locals.statements : [
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
  name       = "${var.namespace}-vm"
  users      = []
  roles      = [module.roles.aws_iam_role.instance_role.name]
  groups     = []
  policy_arn = policy.policy.arn
}