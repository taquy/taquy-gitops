
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
  instance_role_name = "${module.label.id}-instance"
}

# define roles
resource "aws_iam_role" "vm_role" {
  name = local.instance_role_name
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

resource "aws_iam_instance_profile" "vm_profile" {
  name = local.instance_role_name
  role = aws_iam_role.vm_role.name
}

# define policies
module "policy" {
  source    = "./policies"
  namespace = var.namespace
  source_ip = var.source_ip
  roles = {
    instance_role_name = aws_iam_role.vm_role.name
  }
}