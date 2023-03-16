output "vpc_id" {

  description = "The ID of the VPC"
  value       = aws_vpc.main.id

}

output "private_subnet_01_id" {

  description = "The ID of private subnet 01 VPC"
  value       = aws_subnet.private_1.id

}

output "private_subnet_02_id" {

  description = "The ID of private subnet 02 VPC"
  value       = aws_subnet.private_2.id

}

output "public_subnet_01_id" {

  description = "The ID of public subnet 01 VPC"
  value       = aws_subnet.public_1.id

}

output "public_subnet_02_id" {

  description = "The ID of public subnet 02 VPC"
  value       = aws_subnet.public_2.id

}

output "cidr_block" {
  
  description = "the CIDR block"
  value       = aws_vpc.main.cidr_block
  
}