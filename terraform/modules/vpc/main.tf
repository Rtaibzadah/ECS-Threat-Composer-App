# VPC + subnets + IGW + NAT + Security
resource "aws_vpc" "vpc" {
  
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project}"
  }
}

# retrieves AZ's in selected region from AWS
data "aws_availability_zones" "available" {}


# impovement - cidr subnet function , to automatically create a subnet with brackets
resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.vpc.id
  # look into variablising using count and index
  cidr_block = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  #makes following line a public subnet when combined with IGW
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet1-public"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "subnet2-public"
  }
}
# aws_internet_gateway.igw.id
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw-1"
  }
}

resource "aws_route_table" "rt-public-subnet1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "main"
  }
}

resource "aws_route_table_association" "subnet1_assoc" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.rt-public-subnet1.id
}

resource "aws_route_table_association" "subnet2_assoc" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.rt-public-subnet1.id
}

