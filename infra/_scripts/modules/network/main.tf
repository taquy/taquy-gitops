
module "label" {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace = var.namespace
  name      = var.name
  delimiter = "-"
  label_order = ["namespace", "name"]
  tags = var.tags
}

data "aws_availability_zones" "az" {
  state = "available"
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = module.label.tags
}

resource "aws_subnet" "private_subnet_1a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 4, 1)
  availability_zone = data.aws_availability_zones.az.names[0]
  tags = module.label.tags
}

resource "aws_subnet" "public_subnet_1a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 4, 2)
  availability_zone = data.aws_availability_zones.az.names[0]
  tags = module.label.tags
}

resource "aws_subnet" "private_subnet_2b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 4, 3)
  availability_zone = data.aws_availability_zones.az.names[1]
  tags = module.label.tags
}

resource "aws_subnet" "public_subnet_2b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 4, 4)
  availability_zone = data.aws_availability_zones.az.names[1]
  tags = module.label.tags
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = module.label.tags
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 4, 2)
    gateway_id = aws_internet_gateway.igw.id
  }
  route {
    cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 4, 4)
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = module.label.tags
}