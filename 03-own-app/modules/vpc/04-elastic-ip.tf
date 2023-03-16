# ELASTIC IP
resource "aws_eip" "eip" {

  depends_on = [aws_internet_gateway.igw]

  tags = {
    "Name" = "vpc-testing-ip-for-ngw" 
  }

}