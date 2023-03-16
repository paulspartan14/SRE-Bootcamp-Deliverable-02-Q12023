# VPC
resource "aws_vpc" "main" {
    
    cidr_block = var.vpc_cidr
    instance_tenancy     = "default"
    enable_dns_support   = true
    enable_dns_hostnames = true

    tags = {
      "Name" = "vpc-testing"
    }
  
}

# DEFAULT VPC SG
resource "aws_default_security_group" "main_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "vpc-testing-sg-default"
  }

}

# DEFAULT VPC RTB
resource "aws_default_route_table" "main_rtb" {

  default_route_table_id = aws_vpc.main.default_route_table_id

  tags = {
    "Name" = "vpc-testing-rtb-default"
  }

}

# DEFAULT VPC NACL
resource "aws_default_network_acl" "main_acl" {

  default_network_acl_id = aws_vpc.main.default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    "Name" = "vpc-testing-nacl-default"    
  }

}
