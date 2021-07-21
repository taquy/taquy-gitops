
module "label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace   = var.namespace
  delimiter   = "-"
  label_order = ["namespace"]
  tags        = var.tags
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(module.label.tags, {
    "Name" = var.namespace
  })
}

module "subnets" {
  source    = "./subnets"
  namespace = var.namespace
  tags      = var.tags
  vpc_id    = aws_vpc.vpc.id
  vpc_cidr  = aws_vpc.vpc.cidr_block
}

module "rt" {
  depends_on = [
    module.subnets
  ]
  source            = "./rt"
  namespace         = var.namespace
  tags              = var.tags
  vpc_id            = aws_vpc.vpc.id
  private_subnet_1a = module.subnets.private_subnet_1a
  public_subnet_1a  = module.subnets.public_subnet_1a
  private_subnet_2b = module.subnets.private_subnet_2b
  public_subnet_2b  = module.subnets.public_subnet_2b
}

module "sg" {
  source    = "./sg"
  namespace = var.namespace
  tags      = var.tags
  vpc_id    = aws_vpc.vpc.id
  source_ip = var.source_ip
}

module "eni" {
  source       = "./eni"
  namespace    = var.namespace
  tags         = var.tags
  vm_sg_id     = module.sg.vm_sg_id
  vm_subnet_id = module.subnets.public_subnet_1a
}