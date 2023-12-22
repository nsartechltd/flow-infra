#### public 1a
resource "aws_subnet" "public_eu_west_2a" {
  vpc_id               = aws_vpc.flow_vpc.id
  cidr_block           = "10.0.100.0/24"
  availability_zone_id = "euw2-az1"

  tags = {
    Name = "public-eu-west-2a-flow-${var.environment}"
  }
}

resource "aws_route_table_association" "public_eu_west_2a" {
  subnet_id      = aws_subnet.public_eu_west_2a.id
  route_table_id = aws_route_table.igw.id
}

#### public 1b
resource "aws_subnet" "public_eu_west_2b" {
  vpc_id               = aws_vpc.flow_vpc.id
  cidr_block           = "10.0.101.0/24"
  availability_zone_id = "euw2-az2"

  tags = {
    Name = "public-eu-west-2b-flow-${var.environment}"
  }
}

resource "aws_route_table_association" "public_eu_west_2b" {
  subnet_id      = aws_subnet.public_eu_west_2b.id
  route_table_id = aws_route_table.igw.id
}

#### public 1c
resource "aws_subnet" "public_eu_west_2c" {
  vpc_id               = aws_vpc.flow_vpc.id
  cidr_block           = "10.0.102.0/24"
  availability_zone_id = "euw2-az3"

  tags = {
    Name = "public-eu-west-2c-flow-${var.environment}"
  }
}

resource "aws_route_table_association" "public_eu_west_2c" {
  subnet_id      = aws_subnet.public_eu_west_2c.id
  route_table_id = aws_route_table.igw.id
}

#### private 1a
resource "aws_subnet" "private_eu_west_2a" {
  vpc_id               = aws_vpc.flow_vpc.id
  cidr_block           = "10.0.1.0/24"
  availability_zone_id = "euw2-az2"

  tags = {
    Name = "private-eu-west-2a-flow-${var.environment}"
  }
}

resource "aws_route_table_association" "private_eu_west_2a" {
  subnet_id      = aws_subnet.private_eu_west_2a.id
  route_table_id = aws_route_table.ngw.id
}

#### private 1b
resource "aws_subnet" "private_eu_west_2b" {
  vpc_id               = aws_vpc.flow_vpc.id
  cidr_block           = "10.0.2.0/24"
  availability_zone_id = "euw2-az1"

  tags = {
    Name = "private-eu-west-2b-flow-${var.environment}"
  }
}

resource "aws_route_table_association" "private_eu_west_2b" {
  subnet_id      = aws_subnet.private_eu_west_2b.id
  route_table_id = aws_route_table.ngw.id
}

#### private 1c
resource "aws_subnet" "private_eu_west_2c" {
  vpc_id               = aws_vpc.flow_vpc.id
  cidr_block           = "10.0.3.0/24"
  availability_zone_id = "euw2-az3"

  tags = {
    Name = "private-eu-west-2c-flow-${var.environment}"
  }
}

resource "aws_route_table_association" "private_eu_west_2c" {
  subnet_id      = aws_subnet.private_eu_west_2c.id
  route_table_id = aws_route_table.ngw.id
}

resource "aws_db_subnet_group" "flow_subnet_group" {
  name = "db-private-subnets"
  subnet_ids = [
    aws_subnet.private_eu_west_2a.id,
    aws_subnet.private_eu_west_2b.id,
    aws_subnet.private_eu_west_2c.id
  ]

  tags = {
    Name = "subnet-group-flow-${var.environment}"
  }
}