# ----------------------------------------------
# VPC
# ----------------------------------------------
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}


# ----------------------------------------------
# Subnet
# ----------------------------------------------
resource "aws_subnet" "public_dl" {
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${data.aws_region.current.name}a"
  vpc_id            = aws_vpc.vpc.id

  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_dwh" {
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${data.aws_region.current.name}a"
  vpc_id            = aws_vpc.vpc.id

  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_dm" {
  cidr_block        = "10.0.3.0/24"
  availability_zone = "${data.aws_region.current.name}a"
  vpc_id            = aws_vpc.vpc.id
}

resource "aws_subnet" "private_dm1" {
  cidr_block        = "10.0.11.0/25"
  availability_zone = "${data.aws_region.current.name}a"
  vpc_id            = aws_vpc.vpc.id
}

resource "aws_subnet" "private_dm2" {
  cidr_block        = "10.0.11.128/25"
  availability_zone = "${data.aws_region.current.name}c"
  vpc_id            = aws_vpc.vpc.id
}


# ----------------------------------------------
# Gateway
# ----------------------------------------------
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
}


# ----------------------------------------------
# Route Table
# ----------------------------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "ig" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
}


# ----------------------------------------------
# Route
# ----------------------------------------------
resource "aws_route" "public" {
  gateway_id             = aws_internet_gateway.ig.id
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
}


# ----------------------------------------------
# Route Table Association
# ----------------------------------------------
resource "aws_route_table_association" "public_dl" {
  subnet_id      = aws_subnet.public_dl.id
  route_table_id = aws_route_table.ig.id
}

resource "aws_route_table_association" "public_dwh" {
  subnet_id      = aws_subnet.public_dwh.id
  route_table_id = aws_route_table.ig.id
}

resource "aws_route_table_association" "public_dm" {
  subnet_id      = aws_subnet.public_dm.id
  route_table_id = aws_route_table.ig.id
}


# ----------------------------------------------
# VPC Endpoints
# ----------------------------------------------
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.ap-northeast-1.s3"

  route_table_ids = [
    aws_route_table.ig.id,
  ]
}
