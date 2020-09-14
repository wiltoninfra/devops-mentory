# VPC
resource "aws_vpc" "vpc_curso" {
  cidr_block = var.vpc_cidr
  tags = merge(
    var.tags,
    map(
      "Name", "VPC"
    )
  )
}

# Internet Gateway
resource "aws_internet_gateway" "curso_igw" {
  vpc_id = aws_vpc.vpc_curso.id
  tags = merge(
    var.tags,
    map(
      "Name", "VPC"
    )
  )
}

# Subnets Publicas
resource "aws_subnet" "subnet-public" {
  count             = length(var.subnets_cidr_pub)
  vpc_id            = aws_vpc.vpc_curso.id
  cidr_block        = element(var.subnets_cidr_pub, count.index)
  availability_zone = element(var.azs, count.index)
  tags = merge(
    var.tags,
    map(
      "Name", "subnet-public"
    )
  )
}

# Route table attach Internet Gateway 
resource "aws_route_table" "router-public" {
  vpc_id = aws_vpc.vpc_curso.id
  route {
    cidr_block = var.cidr
    gateway_id = aws_internet_gateway.curso_igw.id
  }
  tags = merge(
    var.tags,
    map(
      "Name", "router-public-table"
    )
  )
}

# Route table association with public subnets
resource "aws_route_table_association" "rta" {
  count          = length(var.azs)
  subnet_id      = element(aws_subnet.subnet-public.*.id, count.index)
  route_table_id = aws_route_table.router-public.id
}

resource "aws_eip" "ipwan" {
  vpc = true
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "GW-NAT" {
  count         = length(var.azs)
  allocation_id = element(aws_eip.ipwan.*.id, count.index)
  subnet_id     = element(aws_subnet.subnet-public.*.id, count.index)
  depends_on    = [aws_internet_gateway.curso_igw]
}

# Subnet (private) FrontEnd
resource "aws_subnet" "subnet-private" {
  count                   = length(var.subnets_cidr_pvt)
  vpc_id                  = aws_vpc.vpc_curso.id
  cidr_block              = element(var.subnets_cidr_pvt, count.index)
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = false
  tags = merge(
    var.tags,
    map(
      "Name", "subnet-private"
    )
  )
}

resource "aws_route_table" "route-private" {
  count  = length(var.subnets_cidr_pvt)
  vpc_id = aws_vpc.vpc_curso.id
  tags = merge(
    var.tags,
    map(
      "Name", "router-private-table"
    )
  )
}

resource "aws_route_table_association" "route-private" {
  count          = length(var.subnets_cidr_pvt)
  subnet_id      = element(aws_subnet.subnet-private.*.id, count.index)
  route_table_id = element(aws_route_table.route-private.*.id, count.index)
}

resource "aws_route" "private_nat_gateway" {
  count                  = length(var.subnets_cidr_pvt)
  route_table_id         = element(aws_route_table.route-private.*.id, count.index)
  destination_cidr_block = var.cidr
  nat_gateway_id         = element(aws_nat_gateway.GW-NAT.*.id, count.index)
  depends_on             = [aws_nat_gateway.GW-NAT]
}

# Subnet Banco de Dados
resource "aws_subnet" "subnet-db" {
  count                   = length(var.subnets_cidr_db)
  vpc_id                  = aws_vpc.vpc_curso.id
  cidr_block              = element(var.subnets_cidr_db, count.index)
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = false
  tags = merge(
    var.tags,
    map(
      "Name", "subnet-db"
    )
  )
}

resource "aws_route_table" "route-db" {
  count  = length(var.subnets_cidr_db)
  vpc_id = aws_vpc.vpc_curso.id
  tags = merge(
    var.tags,
    map(
      "Name", "router-private-db"
    )
  )
}

resource "aws_route_table_association" "route-db" {
  count          = length(var.subnets_cidr_db)
  subnet_id      = element(aws_subnet.subnet-db.*.id, count.index)
  route_table_id = element(aws_route_table.route-db.*.id, count.index)
}

resource "aws_route" "db_nat_gateway" {
  count                  = length(var.subnets_cidr_db)
  route_table_id         = element(aws_route_table.route-db.*.id, count.index)
  destination_cidr_block = var.cidr
  nat_gateway_id         = element(aws_nat_gateway.GW-NAT.*.id, count.index)
  depends_on             = [aws_nat_gateway.GW-NAT]
}

resource "aws_default_network_acl" "acl-default" {
  default_network_acl_id = aws_vpc.vpc_curso.default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.vpc_curso.cidr_block
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = var.cidr
    from_port  = 0
    to_port    = 0
  }
}