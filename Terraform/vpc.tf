resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "clusterVPC"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id = aws_vpc.eks_vpc.id
  cidr_block = "10.0.1.0/24"
  /* availability_zone = "us-west-2a" */
  
  tags = {
    Name = "MySubnet"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    Name = "MyIGW"
  }
}

resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.eks_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
  tags = {
    Name = "MyRouteTable"
  }
}

resource "aws_route_table_association" "my_route_table_association" {
  subnet_id = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}
