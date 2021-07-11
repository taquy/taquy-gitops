
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

resource "aws_security_group" "sg" {
  name        = module.label.id
  description = "Security group for instance ${module.label.id}"
  vpc_id      = var.vpc_id
  ingress {
    description = "Ingress HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Ingress HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Ingress SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = merge(module.label.tags, {
    "Name" = module.label.id
  })
}

resource "aws_network_interface" "eni" {
  subnet_id = var.subnet_id
  security_groups = [
    aws_security_group.sg.id
  ]
  tags = merge(module.label.tags, {
    "Name" = module.label.id
  })
}

resource "aws_eip" "eip" {
  vpc               = true
  network_interface = aws_network_interface.eni.id
  tags = merge(module.label.tags, {
    "Name" = module.label.id
  })
}

resource "aws_spot_instance_request" "spot_instance" {
  spot_price                  = var.instance.spot_price
  ami                         = var.instance.ami
  instance_type               = var.instance.type
  associate_public_ip_address = true
  credit_specification {
    cpu_credits = "standard"
  }
  # iam_instance_profile  = ""
  key_name = aws_key_pair.key.key_name
  network_interface {
    network_interface_id  = aws_network_interface.eni.id
    device_index          = 0
    delete_on_termination = true
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