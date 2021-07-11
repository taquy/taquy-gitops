module "label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace   = var.namespace
  name        = var.name
  delimiter   = "-"
  label_order = ["namespace"]
  tags        = var.tags
}

module "sg" {
  source = "../sg"
}

resource "aws_network_interface" "vm_eni" {
  depends_on = [
    aws_security_group.sg,
    module.sg
  ]
  subnet_id = var.subnet_id
  security_groups = [
    sg.aws_security_group.vm_sg.id
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
