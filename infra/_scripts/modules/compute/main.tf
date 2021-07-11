
module "label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace   = var.namespace
  name        = var.name
  delimiter   = "-"
  label_order = ["namespace", "name"]
  tags        = var.tags
}

resource "aws_key_pair" "key" {
  key_name   = module.label.id
  public_key = file(var.key_path)
}

resource "aws_spot_instance_request" "spot_instance" {
  depends_on = [
    module.iam
  ]
  spot_price    = var.instance.spot_price
  ami           = var.instance.ami
  instance_type = var.instance.type
  credit_specification {
    cpu_credits = "standard"
  }
  iam_instance_profile = var.vm_profile_arn
  key_name             = aws_key_pair.key.key_name
  network_interface {
    network_interface_id = aws_network_interface.eni.id
    device_index         = 0
  }
  user_data = var.instance.user_data != "" ? var.instance.user_data : ""
  volume_tags = merge(module.label.tags, {
    "Name" = module.label.id
  })
  tags = merge(module.label.tags, {
    "Name" = module.label.id
  })
  root_block_device {
    delete_on_termination = true
    volume_size           = 20
    volume_type           = "gp3"
  }
}