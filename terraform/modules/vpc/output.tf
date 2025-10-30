output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_ids"  { value = [aws_subnet.subnet1.id, aws_subnet.subnet2.id] }

output "igw-1_id" {
  value = aws_internet_gateway.igw.id
}