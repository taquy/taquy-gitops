
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
  tags                 = module.label.tags
}

resource "aws_subnet" "private_subnet_1a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 1)
  availability_zone = data.aws_availability_zones.az.names[0]
  tags              = module.label.tags
}

resource "aws_subnet" "public_subnet_1a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 2)
  availability_zone = data.aws_availability_zones.az.names[0]
  tags              = module.label.tags
}

resource "aws_subnet" "private_subnet_2b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 3)
  availability_zone = data.aws_availability_zones.az.names[1]
  tags              = module.label.tags
}

resource "aws_subnet" "public_subnet_2b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 4)
  availability_zone = data.aws_availability_zones.az.names[1]
  tags              = module.label.tags
}

# gateways
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = module.label.tags
}

# route tables
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = module.label.tags
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = module.label.tags
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

# prefix list
resource "aws_ec2_managed_prefix_list" "pl_public_subnets" {
  name           = module.label.id
  address_family = "IPv4"
  max_entries    = 2
  entry {
    cidr        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 2)
    description = "Public subnet 2a"
  }
  entry {
    cidr        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 4)
    description = "Public subnet 2b"
  }
  tags = module.label.tags
}

# routes
resource "aws_route" "public_route" {
  route_table_id              = aws_route_table.public_route_table.id
  destination_prefix_list_id = aws_ec2_managed_prefix_list.pl_public_subnets.id
  gateway_id = aws_internet_gateway.igw.id
}
