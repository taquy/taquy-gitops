
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

# define roles
resource "aws_iam_role" "vm_role" {
  name = module.label.id
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
  name = module.label.id
  role = aws_iam_role.vm_role.name
}

# define policies
module "vm_policy" {
  source    = "./policies"
  namespace = var.namespace
  name = module.label.id
  source_ip = var.source_ip
  vm_role = aws_iam_role.vm_role.name
}