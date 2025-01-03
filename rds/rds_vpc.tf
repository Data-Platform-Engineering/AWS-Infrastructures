resource "aws_vpc" "rds-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "rds-vpc"
  }
}

resource "aws_subnet" "rds-public-subnet" {
  vpc_id                  = aws_vpc.rds-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "rds-public-subnet"
  }
}

resource "aws_subnet" "rds-private-subnet" {
  vpc_id            = aws_vpc.rds-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-central-1b"

  tags = {
    Name = "rds-private-subnet"
  }
}

resource "aws_internet_gateway" "rds-custom-igw" {
  vpc_id = aws_vpc.rds-vpc.id

  tags = {
    Name = "rds-custom-igw"
  }
}

resource "aws_route_table" "rds-public-rt" {
  vpc_id = aws_vpc.rds-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rds-custom-igw.id
  }

  tags = {
    Name = "rds-public-rt"
  }
}

resource "aws_route_table_association" "public-subnet-association" {
  subnet_id      = aws_subnet.rds-public-subnet.id
  route_table_id = aws_route_table.rds-public-rt.id
}

resource "aws_route_table_association" "private-subnet-association" {
  subnet_id      = aws_subnet.rds-private-subnet.id
  route_table_id = aws_route_table.rds-public-rt.id
}