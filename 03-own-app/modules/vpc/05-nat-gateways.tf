# NAT GATEWAY
resource "aws_nat_gateway" "ngw" {

  allocation_id = aws_eip.eip.id

  subnet_id = aws_subnet.public_1.id

  tags = {
    "Name" = "vpc-testing-ngw-for-private-subnets" 
  }

}