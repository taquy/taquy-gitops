
module "label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace   = var.namespace
  delimiter   = "-"
  label_order = ["namespace"]
  tags        = var.tags
}

locals {
  internet_cidr = "0.0.0.0/0"
}

locals {
  sg_rules = {
    ingress = {
      "allow-https" = {
        port        = 443
        description = "Ingress HTTPS"
        cidr_blocks = [local.internet_cidr]
      },
      "allow-http" = {
        port        = 80
        description = "Ingress HTTP"
        cidr_blocks = [local.internet_cidr]
      },
      "allow-ssh" = {
        port        = 22
        description = "Ingress SSH"
        cidr_blocks = setunion([], var.source_ip)
      }
    }
  }
}

resource "aws_security_group" "vm_sg" {
  name        = module.label.id
  description = "Security group for instance ${module.label.id}"
  vpc_id      = var.vpc_id

  tags = merge(module.label.tags, {
    "Name" = module.label.id
  })
}

resource "aws_security_group_rule" "ingress_rules" {
  for_each          = local.sg_rules.ingress
  type              = "ingress"
  from_port         = each.value.port != "" ? each.value.port : each.value.from_port
  to_port           = each.value.port != "" ? each.value.port : each.value.to_port
  protocol          = "tcp"
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = aws_security_group.vm_sg.id
}

resource "aws_security_group_rule" "egress_rules" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = [local.internet_cidr]
  security_group_id = aws_security_group.vm_sg.id
}
