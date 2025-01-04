resource "aws_vpc" "rds_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name  = "rds-vpc"
    Owner = "Data Platform Team"
  }
}

resource "aws_subnet" "rds_public_subnet_1" {
  vpc_id            = aws_vpc.rds_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-central-1a"

  tags = {
    Name = "rds-public-subnet-1"
  }
}

resource "aws_subnet" "rds_public_subnet_2" {
  vpc_id            = aws_vpc.rds_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-central-1b"

  tags = {
    Name = "rds-public-subnet-2"
  }
}

resource "aws_internet_gateway" "rds_custom_igw" {
  vpc_id = aws_vpc.rds_vpc.id

  tags = {
    Name = "rds-custom-igw"
  }
}

resource "aws_route_table" "rds_public_rt" {
  vpc_id = aws_vpc.rds_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rds_custom_igw.id
  }

  tags = {
    Name = "rds-public-rt"
  }
}

resource "aws_route_table_association" "public-subnet-association_1" {
  subnet_id      = aws_subnet.rds_public_subnet_1.id
  route_table_id = aws_route_table.rds_public_rt.id
}

resource "aws_route_table_association" "public-subnet-association_2" {
  subnet_id      = aws_subnet.rds_public_subnet_2.id
  route_table_id = aws_route_table.rds_public_rt.id
}