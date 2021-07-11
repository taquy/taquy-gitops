
module "label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace   = var.namespace
  delimiter   = "-"
  label_order = ["namespace"]
  tags        = var.tags
}

data "aws_availability_zones" "az" {
  state = "available"
}

resource "aws_subnet" "private_subnet_1a" {
  vpc_id            = var.vpc_id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 1)
  availability_zone = data.aws_availability_zones.az.names[0]
  tags = merge(module.label.tags, {
    "Name" = "${var.namespace}-private-az1"
  })
}

resource "aws_subnet" "public_subnet_1a" {
  vpc_id            = var.vpc_id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 2)
  availability_zone = data.aws_availability_zones.az.names[0]
  tags = merge(module.label.tags, {
    "Name" = "${var.namespace}-public-az1"
  })
}

resource "aws_subnet" "private_subnet_2b" {
  vpc_id            = var.vpc_id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 3)
  availability_zone = data.aws_availability_zones.az.names[1]
  tags = merge(module.label.tags, {
    "Name" = "${var.namespace}-private-az2"
  })
}

resource "aws_subnet" "public_subnet_2b" {
  vpc_id            = var.vpc_id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 4)
  availability_zone = data.aws_availability_zones.az.names[1]
  tags = merge(module.label.tags, {
    "Name" = "${var.namespace}-public-az2"
  })
}