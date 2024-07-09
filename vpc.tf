# Project VPC
resource "aws_vpc" "project-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "project-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "project-igw" {
  vpc_id = aws_vpc.project-vpc.id
  tags = {
    Name = "project-igw"
  }
  depends_on = [aws_vpc.project-vpc]
}


# Subnets for us_east_1a
resource "aws_subnet" "public_subnet_us_east_1a" {
  vpc_id            = aws_vpc.project-vpc.id
  cidr_block        = var.cidr_block_public_us_east_1a
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet_us_east_1a"
  }
}

resource "aws_subnet" "private_subnet_us_east_1a" {
  vpc_id            = aws_vpc.project-vpc.id
  cidr_block        = var.cidr_block_private_us_east_1a
  availability_zone = "us-east-1a"
  tags = {
    Name = "private_subnet_us_east_1a"
  }
}

# Subnets for us_east_1b
resource "aws_subnet" "public_subnet_us_east_1b" {
  vpc_id            = aws_vpc.project-vpc.id
  cidr_block        = var.cidr_block_public_us_east_1b
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet_us_east_1b"
  }
}

resource "aws_subnet" "private_subnet_us_east_1b" {
  vpc_id            = aws_vpc.project-vpc.id
  cidr_block        = var.cidr_block_private_us_east_1b
  availability_zone = "us-east-1b"
  tags = {
    Name = "private_subnet_us_east_1b"
  }
}








