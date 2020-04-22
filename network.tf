provider "aws" {
  version    = "~> 2.58"
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

resource "aws_vpc" "VPC" {
  cidr_block           = var.vpc-fullcidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "Public_webserver_zone_a" {
  vpc_id     = aws_vpc.VPC.id
  cidr_block = var.Public-subnet-server-a-CIDR

  tags = {
    Name = "Public Web Server Zone A"
  }

  availability_zone = format("%s%s", var.region, "a")
}

resource "aws_route_table_association" "Public_webserver_zone_a" {
  subnet_id      = aws_subnet.Public_webserver_zone_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "Public_webserver_zone_b" {
  vpc_id     = aws_vpc.VPC.id
  cidr_block = var.Public-subnet-server-b-CIDR

  tags = {
    Name = "Public Web Server Zone B"
  }

  availability_zone = format("%s%s", var.region, "b")
}

resource "aws_route_table_association" "Public_webserver_zone_b" {
  subnet_id      = aws_subnet.Public_webserver_zone_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "Public_bastion_zone_a" {
  vpc_id     = aws_vpc.VPC.id
  cidr_block = var.Public-subnet-bastion-a-CIDR

  tags = {
    Name = "Public Bastion Zone A"
  }

  availability_zone = format("%s%s", var.region, "a")
}

resource "aws_route_table_association" "Public_bastion_zone_a" {
  subnet_id      = aws_subnet.Public_bastion_zone_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "Public_bastion_zone_b" {
  vpc_id     = aws_vpc.VPC.id
  cidr_block = var.Public-subnet-bastion-b-CIDR

  tags = {
    Name = "Public Bastion Zone B"
  }

  availability_zone = format("%s%s", var.region, "b")
}

resource "aws_route_table_association" "Public_bastion_zone_b" {
  subnet_id      = aws_subnet.Public_bastion_zone_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "Private-db-zone-a" {
  vpc_id     = aws_vpc.VPC.id
  cidr_block = var.Private-subnet-DBa-CIDR

  tags = {
    Name = "Private DB zone a"
  }

  availability_zone = format("%s%s", var.region, "a")
}

resource "aws_route_table_association" "Private-db-zone-a" {
  subnet_id      = aws_subnet.Private-db-zone-a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_subnet" "Private-db-zone-b" {
  vpc_id     = aws_vpc.VPC.id
  cidr_block = var.Private-subnet-DBb-CIDR

  tags = {
    Name = "Private DB zone b"
  }

  availability_zone = format("%s%s", var.region, "b")
}

resource "aws_route_table_association" "Private-db-zone-b" {
  subnet_id      = aws_subnet.Private-db-zone-b.id
  route_table_id = aws_route_table.private.id
}

resource "aws_db_subnet_group" "db" {
  name        = "db"
  description = "Our main group of subnets"
  subnet_ids  = [aws_subnet.Private-db-zone-a.id, aws_subnet.Private-db-zone-b.id]
}
