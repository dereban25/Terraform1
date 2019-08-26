#Provision:
#-VPC;
#-Internet gateway
#-Public,Private subnet
#-NAT Gateways in Public Subnets to give access to Internet from Private Subnets

provider "aws" {
  region = "us-west-1"
}

data "aws_availability_zones" "available" {}
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags       = {
	Name = "${var.env} - vpc"
  }
}
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = {
	Name = "${var.env} -IGW"
  }
}
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  cidr_block              = var.public_subnets[ count.index ]
  availability_zone       = data.aws_availability_zones.available.names[ count.index ]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
  tags                    = {
	Name = "${var.env} - public - ${count.index + 1}"
  }
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
	cidr_block = "0.0.0.0/0"gateway_id = aws_internet_gateway.main.id
  }
  tags   = {
	Name = "${var.env} - route_public_subnet"
  }
}
resource "aws_route_table_association" "public_routes" {
  count          = length(aws_subnet.public[ * ].id)
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[ * ].id[ count.index ]
}

#----------- NAT Gateway with Elastic IP -----------#
resource "aws_eip" "nat" {
  count = length(var.private_subnets)
  vpc   = true
  tags  = {
	Name = "${var.env} - nat_GW - ${count.index +1}"
  }
}
resource "aws_nat_gateway" "nat_gw" {
  count         = length(var.private_subnets)
  allocation_id = aws_eip.nat[ count.index ].id
  subnet_id     = aws_subnet.public[ * ].id[ count.index ]
  tags          = {
	Name = "${var.env} - nat_GW - ${count.index +1}"
  }
}

#----------- Private Subnets and Routing -----------#
resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  cidr_block        = var.private_subnets[ count.index ]
  vpc_id            = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[ count.index ]
  tags              = {
	Name = "${var.env} - private - ${count.index +1}"
  }
}
resource "aws_route_table" "private" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.main.id
  route {
	cidr_block = "0.0.0.0/0"
	gateway_id = aws_nat_gateway.nat_gw[ count.index ].id
  }
  tags   = {
	Name = "${var.env} - route_private - ${count.index +1}"
  }
}
resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private[ * ].id)
  route_table_id = aws_route_table.private[ count.index ].id
  subnet_id      = aws_subnet.private[ * ].id[ count.index ]
}