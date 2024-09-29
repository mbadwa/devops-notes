# VPC resource creation
resource "aws_vpc" "dove" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    tags = {
      Name = "dove-vpc"
    }
}

# Public Subnets Resources Creation
resource "aws_subnet" "dove-pub-1" {
    vpc_id = aws_vpc.dove.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = var.ZONE1
    tags = {
      Name = "dove-pub-1"
    }  
}

resource "aws_subnet" "dove-pub-2" {
    vpc_id = aws_vpc.dove.id
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = var.ZONE2
    tags = {
      Name = "dove-pub-2"
    }  
}

resource "aws_subnet" "dove-pub-3" {
    vpc_id = aws_vpc.dove.id
    cidr_block = "10.0.3.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = var.ZONE3
    tags = {
      Name = "dove-pub-3"
    }  
}

# Private Subnets Resources Creation
resource "aws_subnet" "dove-pvt-1" {
    vpc_id = aws_vpc.dove.id
    cidr_block = "10.0.4.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = var.ZONE1
    tags = {
      Name = "dove-pvt-1"
    }  
}

resource "aws_subnet" "dove-pvt-2" {
    vpc_id = aws_vpc.dove.id
    cidr_block = "10.0.5.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = var.ZONE2
    tags = {
      Name = "dove-pvt-2"
    }  
}

resource "aws_subnet" "dove-pvt-3" {
    vpc_id = aws_vpc.dove.id
    cidr_block = "10.0.6.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = var.ZONE3
    tags = {
      Name = "dove-pvt-3"
    }  
}

# Internet Gateway Resource Creation
resource "aws_internet_gateway" "dove-IGW" {
  vpc_id = aws_vpc.dove.id
  tags = {
    Name = "dove-IGW"
  }
}

# Route Table Creation to Join the Pub VPC
resource "aws_route_table" "dove-pub-RT" {
  vpc_id = aws_vpc.dove.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dove-IGW.id
  }

  tags = {
    Name = "dove-pub-RT"
  }
}

# Route Table Assocition with the Pub Subnets
resource "aws_route_table_association" "dove-pub-1-a" {
  subnet_id = aws_subnet.dove-pub-1.id
  route_table_id = aws_route_table.dove-pub-RT.id
}

resource "aws_route_table_association" "dove-pub-2-b" {
  subnet_id = aws_subnet.dove-pub-2.id
  route_table_id = aws_route_table.dove-pub-RT.id
}

resource "aws_route_table_association" "dove-pub-3-c" {
  subnet_id = aws_subnet.dove-pub-3.id
  route_table_id = aws_route_table.dove-pub-RT.id
}