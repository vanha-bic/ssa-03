provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    "Name" = "vpc-custom"
  }
}

resource "aws_subnet" "public-subnet-ap-southeast-1a" {
  availability_zone = "ap-southeast-1a"
  cidr_block        = "10.0.0.0/22"
  vpc_id            = aws_vpc.my_vpc.id

  tags = {
    "Name" = "public-subnet"
  }
}

resource "aws_subnet" "private-subnet-ap-southeast-1a" {
  availability_zone = "ap-southeast-1a"
  cidr_block        = "10.0.4.0/22"
  vpc_id            = aws_vpc.my_vpc.id

  tags = {
    "Name" = "private-subnet"
  }
}

resource "aws_subnet" "public-subnet-ap-southeast-1b" {
  availability_zone = "ap-southeast-1b"
  cidr_block        = "10.0.8.0/22"
  vpc_id            = aws_vpc.my_vpc.id

  tags = {
    "Name" = "public-subnet"
  }
}

resource "aws_subnet" "private-subnet-ap-southeast-1b" {
  availability_zone = "ap-southeast-1b"
  cidr_block        = "10.0.12.0/22"
  vpc_id            = aws_vpc.my_vpc.id

  tags = {
    "Name" = "private-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    "Name" = "igw"
  }
}


resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

}

resource "aws_eip" "nat-eip-ap-southeast-1a" {
  domain = "vpc"

  tags = {
    "Name" = "nat-eip"
  }
}

resource "aws_nat_gateway" "nat-gateway-ap-southeast-1a" {
  allocation_id = aws_eip.nat-eip-ap-southeast-1a.id
  subnet_id     = aws_subnet.public-subnet-ap-southeast-1a.id

  tags = {
    "Name" = "nat-gateway"
  }
}

resource "aws_route_table" "private-route-table-ap-southeast-1a" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gateway-ap-southeast-1a.id
  }
}
