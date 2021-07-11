
module "label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace   = var.namespace
  delimiter   = "-"
  label_order = ["namespace"]
  tags        = var.tags
}


# gateways
resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
  tags   = module.label.tags
}

# route tables
resource "aws_route_table" "private_route_table" {
  vpc_id = var.vpc_id
  tags = merge(module.label.tags, {
    "Name" = "${var.namespace}-private-rt"
  })
}

resource "aws_route_table" "public_route_table" {
  vpc_id = var.vpc_id
  tags = merge(module.label.tags, {
    "Name" = "${var.namespace}-public-rt"
  })
}

# route table associations
resource "aws_route_table_association" "rt_private_subnet_1a" {
  subnet_id      = var.private_subnet_1a
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "rt_private_subnet_2b" {
  subnet_id      = var.private_subnet_2b
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "rt_public_subnet_1a" {
  subnet_id      = var.public_subnet_1a
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "rt_public_subnet_2b" {
  subnet_id      = var.public_subnet_2b
  route_table_id = aws_route_table.public_route_table.id
}

# routes
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}