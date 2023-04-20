
#vpc creation
resource "aws_vpc" "main-vpc" {
  cidr_block       = var.cidr
  enable_dns_hostnames = var.dns-hostname[0]
  enable_dns_support = var.dns-support[0]

  tags = {
    Name   = "paradin"
    Project = "EKS"
  }
}

#subnets creation
resource "aws_subnet" "main-subnet" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = var.subnetcidr[count.index]
  count = length(var.subnetcidr)
   
  tags = {
    Name   = "Paradin"
    Project = "EKS"
  }
}


#IGW creation
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Project = "EKS"
  }
}


#create route for IGW

resource "aws_route_table" "route2igw" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

#associate public subnets to the route

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main-subnet[0].id
  route_table_id = aws_route_table.route2igw.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.main-subnet[2].id
  route_table_id = aws_route_table.route2igw.id
}

#splat
output "subnetid1" {
  value = aws_subnet.main-subnet[*].id
}


#security group
resource "aws_security_group" "sg" {
  name        = "dynamic-sg"
  description = "Ingress for Vault"
  vpc_id = aws_vpc.main-vpc.id
  dynamic "ingress" {
    for_each = var.port-sg
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}