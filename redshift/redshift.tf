resource "aws_vpc" "dpe_vpc" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "dpe_vpc"
  }
}

resource "aws_subnet" "subnet_1" {
  vpc_id     = aws_vpc.dpe_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-central-1a"

  tags = {
    Name = "subnet_1"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id     = aws_vpc.dpe_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-central-1b"

  tags = {
    Name = "subnet_2"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.dpe_vpc.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "dpe_rt" {
  vpc_id = aws_vpc.dpe_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "dpe_rt"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.dpe_rt.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.dpe_rt.id
}

#Security Groups
resource "aws_security_group" "dpe_allow_tls" {
  name        = "dpe_allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.dpe_vpc.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 5439
  ip_protocol       = "tcp"
  to_port           = 5439
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


resource "aws_redshift_subnet_group" "dpe_redshift_sg" {
  name       = "dpe-redshift-sg"
  subnet_ids = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]

  tags = {
    environment = "Production"
  }
}


resource "aws_redshift_cluster" "example" {
  cluster_identifier = "tf-redshift-cluster"
  database_name      = "dpedb"
  master_username    = "dpeuser"
  master_password    = "DataPlatform1"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  cluster_subnet_group_name = aws_redshift_subnet_group.dpe_redshift_sg.id
  node_type          = "dc2.large"
  cluster_type       = "multi-node"
}


