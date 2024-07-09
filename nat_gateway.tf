# Create Elastic IP for NAT Gateway
resource "aws_eip" "nat-eip" {
  depends_on = [aws_internet_gateway.project-igw]
}

# Create NAT Gateway in us_east_1a
resource "aws_nat_gateway" "nat-gateway-1a" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.public_subnet_us_east_1a.id
  tags = {
    Name = "nat-gateway-1a"
  }
  depends_on = [aws_eip.nat-eip]
}

# Public and Private Route Tables
resource "aws_route_table" "public_route_table_us_east_1a" {
  vpc_id = aws_vpc.project-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project-igw.id
  }
  tags = {
    Name = "public_route_table_us_east_1a"
  }
}

resource "aws_route_table" "private_route_table_us_east_1a" {
  vpc_id = aws_vpc.project-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway-1a.id
  }
  tags = {
    Name = "private_route_table_us_east_1a"
  }
}

# Route Table Associations

# Associating public subnets with public route table in us-east-1a
resource "aws_route_table_association" "public-route-table-assoc-us-east-1b" {
  subnet_id      = aws_subnet.public_subnet_us_east_1b.id
  route_table_id = aws_route_table.public_route_table_us_east_1a.id
}

resource "aws_route_table_association" "public-route-table-assoc-us-east-1a" {
  subnet_id      = aws_subnet.public_subnet_us_east_1a.id
  route_table_id = aws_route_table.public_route_table_us_east_1a.id
}

# Associating private subnets with private route table in us-east-1a
resource "aws_route_table_association" "private-route-table-assoc-us-east-1b" {
  subnet_id      = aws_subnet.private_subnet_us_east_1b.id
  route_table_id = aws_route_table.private_route_table_us_east_1a.id
}
resource "aws_route_table_association" "private-route-table-assoc-us-east-1a" {
  subnet_id      = aws_subnet.private_subnet_us_east_1a.id
  route_table_id = aws_route_table.private_route_table_us_east_1a.id
}


