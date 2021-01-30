locals {
  azs_len = length(var.azs)
}

########### VPC ###########

resource "aws_vpc" "this" {
  cidr_block = var.cidr_block

  tags = {
    "Name" = "My-Vpc"
  }
}

########### PUBLIC SUBNET ###########

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, 8, count.index + 1)
  availability_zone = var.azs[count.index]

  count = local.azs_len

  tags = {
    "Name" = "${aws_vpc.this.id}-${var.azs[count.index]}-private-subnet"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  count  = local.azs_len

  tags = {
    "Name" = "${var.azs[count.index]}-private-rt"
  }
}

resource "aws_route_table_association" "private" {
  count = local.azs_len

  route_table_id = aws_route_table.private.*.id[count.index]
  subnet_id      = aws_subnet.private.*.id[count.index]
}

########### PUBLIC SUBNET ###########

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, 8, (count.index + 1) + local.azs_len)
  availability_zone = var.azs[count.index]

  count = local.azs_len

  tags = {
    "Name" = "${aws_vpc.this.id}-${var.azs[count.index]}-public-subnet"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  count  = local.azs_len

  tags = {
    "Name" = "${var.azs[count.index]}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count = local.azs_len

  route_table_id = aws_route_table.public.*.id[count.index]
  subnet_id      = aws_subnet.public.*.id[count.index]
}

########### INTERNET GATEWAY ###########

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    "Name" = "${aws_vpc.this.id}-igw"
  }
}

########### NAT GATEWAY ###########

resource "aws_eip" "this" {
  vpc   = true
  count = local.azs_len
}

resource "aws_nat_gateway" "this" {
  count = local.azs_len

  subnet_id     = aws_subnet.public.*.id[count.index]
  allocation_id = aws_eip.this.*.id[count.index]

  tags = {
    "Name" = "${aws_subnet.public.*.id[count.index]}-ngw"
  }
}

########### ROUTING ###########

# Public subnet will be able to talk to internet freely via the internet gateway
resource "aws_route" "public_igw_route" {
  count = local.azs_len

  route_table_id         = aws_route_table.public.*.id[count.index]
  gateway_id             = aws_internet_gateway.this.id
  destination_cidr_block = var.destination_cidr_block
}

# Private subnet only be able to talk to internet via NAT gateway
# But internet traffic won't be able to come inside the private subnet
resource "aws_route" "private_ngw_route" {
  count = local.azs_len

  route_table_id         = aws_route_table.private.*.id[count.index]
  nat_gateway_id         = aws_nat_gateway.this.*.id[count.index]
  destination_cidr_block = var.destination_cidr_block
}
