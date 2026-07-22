data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-vpc"
    }
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-igw"
    }
  )
}

resource "aws_subnet" "main" {
  for_each = local.subnets

  vpc_id = aws_vpc.main.id

  cidr_block = each.value.cidr

  availability_zone = data.aws_availability_zones.available.names[
    each.value.availability_zone_offset
  ]

  map_public_ip_on_launch = each.value.map_public_ip

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-${replace(each.key, "_", "-")}"
      Tier = each.value.tier
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-public-rt"
      Tier = "public"
    }
  )
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table" "application" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-application-rt"
      Tier = "application"
    }
  )
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-database-rt"
      Tier = "database"
    }
  )
}

resource "aws_route_table_association" "public" {
  for_each = {
    for key, subnet in aws_subnet.main :
    key => subnet
    if local.subnets[key].tier == "public"
  }

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "application" {
  for_each = {
    for key, subnet in aws_subnet.main :
    key => subnet
    if local.subnets[key].tier == "application"
  }

  subnet_id      = each.value.id
  route_table_id = aws_route_table.application.id
}

resource "aws_route_table_association" "database" {
  for_each = {
    for key, subnet in aws_subnet.main :
    key => subnet
    if local.subnets[key].tier == "database"
  }

  subnet_id      = each.value.id
  route_table_id = aws_route_table.database.id
}