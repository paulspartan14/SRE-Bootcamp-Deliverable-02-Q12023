# PUBLIC SUBNET 01
resource "aws_subnet" "public_1" {

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.vpc_public_subnet_01 # public subnet 01
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "vpc-testing-subnet-public-1"  
  }

}

# PUBLIC SUBNET 02
resource "aws_subnet" "public_2" {

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.vpc_public_subnet_02 # public subnet 02
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "vpc-testing-subnet-public-2" 
  }

}

# PRIVATE SUBNET 01
resource "aws_subnet" "private_1" {

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.vpc_private_subnet_01 # private subnet 01
  availability_zone = "${var.aws_region}a"

  tags = {
    "Name" = "vpc-testing-subnet-private-1" 
  }

}

# PRIVATE SUBNET 02
resource "aws_subnet" "private_2" {

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.vpc_private_subnet_02 # private subnet 02
  availability_zone = "${var.aws_region}b"

  tags = {
    "Name" = "vpc-testing-subnet-private-2" 
  }

}