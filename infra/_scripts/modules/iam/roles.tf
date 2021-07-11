
module "label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace   = var.namespace
  delimiter   = "-"
  label_order = ["namespace"]
  tags        = var.tags
}

resource "random_id" "sid" {
  byte_length = 4
}

resource "aws_iam_role" "vm_role" {
  name = "${var.namespace}-vm"
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
  name = "${module.label.id}-vm"
  role = aws_iam_role.vm_role.name
}