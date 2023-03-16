# PUBLIC RTB
resource "aws_route_table" "public" {

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    "Name" = "vpc-testing-rt-public-subnets"
  }

}

# PRIVATE RTB
resource "aws_route_table" "private" {

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    "Name" = "vpc-testing-rt-private-subnets"
  }

}
