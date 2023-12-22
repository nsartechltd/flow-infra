# IGW
resource "aws_internet_gateway" "flow_internet_gateway" {
  vpc_id = aws_vpc.flow_vpc.id

  tags = {
    Name = "flow-${var.environment}"
  }
}

resource "aws_route_table" "igw" {
  vpc_id = aws_vpc.flow_vpc.id

  tags = {
    Name = "flow-${var.environment}"
  }
}

resource "aws_route" "igw" {
  route_table_id         = aws_route_table.igw.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.flow_internet_gateway.id
}

# NGW
resource "aws_route_table" "ngw" {
  vpc_id = aws_vpc.flow_vpc.id

  tags = {
    Name = "flow-${var.environment}"
  }
}

resource "aws_route" "ngw" {
  route_table_id         = aws_route_table.ngw.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.flow_nat_gateway.id
}

### NOTE ###
resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "flow_nat_gateway" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_eu_west_2a.id

  tags = {
    Name = "flow-${var.environment}"
  }
}