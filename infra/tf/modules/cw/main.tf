module "label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace   = var.namespace
  delimiter   = "-"
  label_order = ["namespace"]
  tags        = var.tags
}

resource "aws_cloudwatch_log_group" "cw_log_instance" {
  name              = "${module.label.id}-instance"
  retention_in_days = 1
  tags              = module.label.tags
}