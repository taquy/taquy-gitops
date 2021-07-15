
resource "random_id" "sid" {
  byte_length = 4
}
resource "random_string" "name" {
  length           = 6
  special          = false
  number = false
  upper = false
  lower = true
}
module "label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace   = var.namespace
  name = random_string.name.result
  delimiter   = "-"
  label_order = ["namespace", "name"]
  tags        = var.tags
}

locals {
  instance_role = "${module.label.id}-instance"
  jenkins_node_user = "${module.label.id}-jenkins-node"
  jenkins_job_role = "${module.label.id}-jenkins-job"
}

# define roles
resource "aws_iam_role" "instance_role" {
  name = local.instance_role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = random_id.sid.hex
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  tags = module.label.tags
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = local.instance_role
  role = aws_iam_role.instance_role.name
}

# define jenkins user
resource "aws_iam_user" "jenkins_node_user" {
  name = local.jenkins_node_user
  path = "/"
  tags = module.label.tags
}

# define jenkins job role
resource "aws_iam_role" "jenkins_job_role" {
  name = local.jenkins_job_role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = random_id.sid.hex
        Principal = {
          AWS = "${aws_iam_user.jenkins_node_user.arn}"
        }
      },
    ]
  })
  tags = module.label.tags
}

# define policies
module "policy" {
  source    = "./policies"
  namespace = var.namespace
  source_ip = var.source_ip
  
  identities = {
    jenkins_node = {
      name = aws_iam_user.jenkins_node_user.name
      arn = aws_iam_user.jenkins_node_user.arn
      users = [aws_iam_user.jenkins_node_user.name]
      groups = []
      roles = []
    }
    instance = {
      name = aws_iam_role.instance_role.name
      arn = aws_iam_role.instance_role.arn
      users = []
      groups = [aws_iam_role.instance_role.name]
      roles = []
    }
    jenkins_job = {
      name = aws_iam_role.jenkins_job_role.name
      arn = aws_iam_role.jenkins_job_role.arn
      users = []
      groups = []
      roles = [aws_iam_role.jenkins_job_role.name]
    }
  }
}