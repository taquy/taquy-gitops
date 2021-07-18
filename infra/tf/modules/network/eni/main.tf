module "label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace   = var.namespace
  delimiter   = "-"
  label_order = ["namespace"]
  tags        = var.tags
}

resource "aws_network_interface" "vm_eni" {
  subnet_id = var.vm_subnet_id
  security_groups = [
    var.vm_sg_id
  ]
  tags = merge(module.label.tags, {
    "Name" = module.label.id
  })
}

resource "aws_eip" "vm_eip" {
  depends_on = [
    aws_network_interface.vm_eni
  ]
  vpc               = true
  network_interface = aws_network_interface.vm_eni.id
  tags = merge(module.label.tags, {
    "Name" = module.label.id
  })
}
