module "label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace   = var.namespace
  delimiter   = "-"
  label_order = ["namespace"]
  tags        = var.tags
}

resource "aws_network_interface" "vm_eni" {
  depends_on = [
    aws_security_group.sg,
  ]
  subnet_id = var.subnet_id
  security_groups = [
    var.sg_id
  ]
  tags = merge(module.label.tags, {
    "Name" = module.label.id
  })
}

resource "aws_eip" "vm_eip" {
  depends_on = [
    aws_network_interface.eni
  ]
  vpc               = true
  network_interface = aws_network_interface.vm_eni.id
  tags = merge(module.label.tags, {
    "Name" = module.label.id
  })
}
