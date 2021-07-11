
module "label" {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace = var.namespace
  name      = var.name
  delimiter = "-"
  label_order = ["namespace", "name"]
  tags = var.tags
}

module "roles" {
  source = "../roles"
}

resource "aws_iam_policy" "policy" {
  depends_on = [
    module.roles.aws_iam_role.instance_role,
  ]
  name        = "${var.namespace}-vm"
  path        = "/"
  description = "Instance policy for ${var.namespace}-vm"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
          "Sid": "VisualEditor0",
          "Effect": "Allow",
          "Action": [
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
          "Resource": "arn:aws:ecr:${var.region}:${var.account_id}:repository/*",
          "Condition": {
              "IpAddress": {
                "aws:SourceIp": var.source_ip
              }
          }
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
              "ecr:GetRegistryPolicy",
              "ecr:DescribeRegistry",
              "ecr:GetAuthorizationToken"
            ],
            "Resource": "*",
            "Condition": {
              "IpAddress": {
                  "aws:SourceIp": var.source_ip
              }
            }
        },
        {
          "Sid": "VisualEditor2",
          "Effect": "Allow",
          "Action": [
            "logs:CreateLogStream",
            "logs:DescribeLogStreams",
            "logs:CreateLogGroup"
          ],
          "Resource": "arn:aws:logs:${var.region}:${var.account_id}:log-group:*",
          "Condition": {
            "IpAddress": {
              "aws:SourceIp": var.source_ip
            }
          }
        },
        {
          "Sid": "VisualEditor3",
          "Effect": "Allow",
          "Action": "logs:PutLogEvents",
          "Resource": "arn:aws:logs:${var.region}:${var.account_id}:log-group:*:log-stream:*"
          "Condition": {
            "IpAddress": {
              "aws:SourceIp": var.source_ip
            }
          }
        },
        {
          "Sid": "VisualEditor4",
          "Effect": "Allow",
          "Action": "s3:GetObject",
          "Resource": "arn:aws:s3:::taquy-deploy/*",
          "Condition": {
            "IpAddress": {
              "aws:SourceIp": var.source_ip
            }
          }
        },
        {
          "Sid": "VisualEditor5",
          "Effect": "Allow",
          "Action": "s3:ListBucket",
          "Resource": "*",
          "Condition": {
            "IpAddress": {
              "aws:SourceIp": var.source_ip
            }
          }
        },
        {
          "Sid": "VisualEditor6",
          "Effect": "Allow",
          "Action": "s3:ListAllMyBuckets",
          "Resource": "*",
          "Condition": {
            "IpAddress": {
              "aws:SourceIp": var.source_ip
            }
          }
        },
        {
          "Sid": "VisualEditor7",
          "Effect": "Allow",
          "Action": [
            "s3:PutObject",
            "s3:DeleteObject",
            "s3:PutObjectAcl"
          ],
          "Resource": [
            "arn:aws:s3:::taquy-master/*",
            "arn:aws:s3:::taquy-backup/*"
          ],
          "Condition": {
            "IpAddress": {
              "aws:SourceIp": var.source_ip
            }
          }
        }
    ]
  })
}

resource "aws_iam_policy_attachment" "policy_attachment" {
  name       = "${var.namespace}-vm"
  users      = []
  roles      = [module.roles.aws_iam_role.instance_role.name]
  groups     = []
  policy_arn = policy.policy.arn
}