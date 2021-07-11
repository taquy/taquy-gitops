
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

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(module.label.tags, {
    "Name" = var.namespace
  })
}

resource "aws_subnet" "private_subnet_1a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 1)
  availability_zone = data.aws_availability_zones.az.names[0]
  tags = merge(module.label.tags, {
    "Name" = "${var.namespace}-private-az1"
  })
}

resource "aws_subnet" "public_subnet_1a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 2)
  availability_zone = data.aws_availability_zones.az.names[0]
  tags = merge(module.label.tags, {
    "Name" = "${var.namespace}-public-az1"
  })
}

resource "aws_subnet" "private_subnet_2b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 3)
  availability_zone = data.aws_availability_zones.az.names[1]
  tags = merge(module.label.tags, {
    "Name" = "${var.namespace}-private-az2"
  })
}

resource "aws_subnet" "public_subnet_2b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 4)
  availability_zone = data.aws_availability_zones.az.names[1]
  tags = merge(module.label.tags, {
    "Name" = "${var.namespace}-public-az2"
  })
}

# gateways
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = module.label.tags
}

# route tables
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(module.label.tags, {
    "Name" = "${var.namespace}-private-rt"
  })
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(module.label.tags, {
    "Name" = "${var.namespace}-public-rt"
  })
}

# route table associations
resource "aws_route_table_association" "rt_private_subnet_1a" {
  subnet_id      = aws_subnet.private_subnet_1a.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "rt_private_subnet_2b" {
  subnet_id      = aws_subnet.private_subnet_2b.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "rt_public_subnet_1a" {
  subnet_id      = aws_subnet.public_subnet_1a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "rt_public_subnet_2b" {
  subnet_id      = aws_subnet.public_subnet_2b.id
  route_table_id = aws_route_table.public_route_table.id
}

# routes
resource "aws_route" "public_route" {
  route_table_id             = aws_route_table.public_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                 = aws_internet_gateway.igw.id
}
