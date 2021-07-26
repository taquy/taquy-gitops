data "aws_region" "current_region" {}

data "aws_caller_identity" "current_identity" {}

locals {
  region     = data.aws_region.current_region.name
  account_id = data.aws_caller_identity.current_identity.account_id
  source_ip  = var.source_ip
  policies = {
    jenkins_node = {
      "${var.namespace}AssumeRole" = {
        actions = [
          "sts:AssumeRole",
        ],
        resources = [
          var.identities.jenkins_job.arn,
        ]
      },
      "${var.namespace}GetSessionToken" = {
        actions = [
          "sts:GetSessionToken",
          "sts:GetCallerIdentity"
        ],
        resources = "*"
      },
    },
    jenkins_job = {
      "${var.namespace}KmsList" = {
        actions = [
          "kms:ListKeys"
        ],
        resources = [
          "*",
        ]
      },
      "${var.namespace}KmsGetKey" = {
        actions = [
          "kms:Decrypt",
        ],
        resources = [
          "arn:aws:ecr:${local.region}:${local.account_id}:key/235356b5-71fc-4f10-8324-e041bc259be2",
        ]
      },
       "${var.namespace}KmsDescribeKey" = {
        actions = [
          "kms:DescribeKey"
        ],
        resources = [
          "arn:aws:ecr:${local.region}:${local.account_id}:key/*",
        ]
      },
      "${var.namespace}EcrReadImages" = {
        actions = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:DescribeImages",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
        ],
        resources = [
          "arn:aws:ecr:${local.region}:${local.account_id}:repository/node",
        ]
      },
      "${var.namespace}EcrPushImages" = {
        actions = [
          "ecr:CompleteLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:InitiateLayerUpload",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage"
        ],
        resources = [
          "arn:aws:ecr:${local.region}:${local.account_id}:repository/taquy-api",
        ]
      },
      "${var.namespace}EcrAuthentication" = {
        actions = [
          "ecr:GetAuthorizationToken"
        ],
        resources = "*"
      },
      "${var.namespace}GetSecrets" = {
        actions = [
          "secretsmanager:GetSecretValue",
        ],
        resources = "arn:aws:logs:${local.region}:${local.account_id}:secret:*"
      },
       "${var.namespace}ListSecrets" = {
        actions = [
          "secretsmanager:ListSecrets"
        ],
        resources = "*"
      },
      "${var.namespace}GetIdentity" = {
        actions   = "sts:GetCallerIdentity",
        resources = "*"
      },
    },
    instance = {
      "${var.namespace}KmsList" = {
        actions = [
          "kms:ListKeys"
        ],
        resources = [
          "arn:aws:ecr:${local.region}:${local.account_id}:key/*",
        ]
      },
      "${var.namespace}KmsGetKey" = {
        actions = [
          "kms:Decrypt",
          "kms:DescribeKey"
        ],
        resources = [
          "arn:aws:ecr:${local.region}:${local.account_id}:key/235356b5-71fc-4f10-8324-e041bc259be2",
        ]
      },
      "${var.namespace}GetSecrets" = {
        actions = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:ListSecrets"
        ],
        resources = "arn:aws:logs:${local.region}:${local.account_id}:secret:*"
      },
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
          "logs:DescribeLogStreams",
          "logs:CreateLogStream",
        ],
        resources = "arn:aws:logs:${local.region}:${local.account_id}:log-group:*"
      },
      "${var.namespace}CwLogs" = {
        actions = [
          "logs:CreateLogGroup"
        ],
        resources = "*"
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
}

resource "aws_iam_policy" "policy" {
  for_each = local.policies

  name        = var.identities[each.key].name
  path        = "/"
  description = "Policy for ${var.identities[each.key].name}"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : flatten([
      for sid, statement in each.value : [
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
  for_each = local.policies

  name       = var.identities[each.key].name
  users      = var.identities[each.key].users != [] ? var.identities[each.key].users : []
  roles      = var.identities[each.key].roles != [] ? var.identities[each.key].roles : []
  groups     = var.identities[each.key].groups != [] ? var.identities[each.key].groups : []
  policy_arn = aws_iam_policy.policy[each.key].arn
}