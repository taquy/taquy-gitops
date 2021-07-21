
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

data "aws_s3_bucket_object" "user_data_obj" {
  bucket = var.instance.user_data.bucket_name
  key    = var.instance.user_data.key
}

data "template_file" "user_data_tpl" {
  template = data.aws_s3_bucket_object.user_data_obj.body
}

resource "aws_spot_instance_request" "spot_instance" {
  spot_price    = var.instance.spot_price
  ami           = var.instance.ami
  instance_type = var.instance.type
  credit_specification {
    cpu_credits = "standard"
  }
  spot_type            = "one-time"
  iam_instance_profile = var.instance_profile.name
  key_name             = aws_key_pair.key.key_name
  network_interface {
    network_interface_id = var.vm_eni
    device_index         = 0
  }
  user_data_base64 = base64encode(data.template_file.user_data_tpl.rendered)
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