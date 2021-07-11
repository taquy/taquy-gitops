
module "label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace   = var.namespace
  name        = var.name
  delimiter   = "-"
  label_order = ["namespace", "name"]
  tags        = var.tags
}

module "sg" {
  source = "../sg"
}

resource "aws_network_interface" "eni" {
  depends_on = [
    aws_security_group.sg,
    module.sg
  ]
  subnet_id = var.subnet_id
  security_groups = [
    sg.aws_security_group.sg.id
  ]
  tags = merge(module.label.tags, {
    "Name" = module.label.id
  })
}

resource "aws_eip" "eip" {
  depends_on = [
    aws_network_interface.eni
  ]
  vpc               = true
  network_interface = aws_network_interface.eni.id
  tags = merge(module.label.tags, {
    "Name" = module.label.id
  })
}
