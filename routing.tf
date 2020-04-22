resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.VPC.id

  tags = {
    Name = "IGW for VPC"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.VPC.id

  tags = {
    Name = "Public"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_main_route_table_association" "new_main_route_table" {
  vpc_id         = aws_vpc.VPC.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.VPC.id

  tags = {
    Name = "Private"
  }
}
