resource "aws_vpc" "FIQ_VPC" {
  cidr_block = var.VPCCidr_Block
  tags = {
    Name = var.environment
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "FIQ_IG" {
  vpc_id = aws_vpc.FIQ_VPC.id
  tags = merge(
    var.tags,
    map(
      "project", var.project,
      "environment", var.environment
    )
  )
}

# Create three public subnet
resource "aws_subnet" "public_subnet1" {
  vpc_id     = aws_vpc.FIQ_VPC.id
  cidr_block = var.PublicSubnetCidr_Blocks[0]
  availability_zone = var.availability_zones[0]
  map_public_ip_on_launch = true
  tags = merge(
    var.tags,
    map(
      "project", var.project,
      "environment", var.environment
    )
  )
}

resource "aws_subnet" "public_subnet2" {
  vpc_id     = aws_vpc.FIQ_VPC.id
  cidr_block = var.PublicSubnetCidr_Blocks[1]
  availability_zone = var.availability_zones[1]
  map_public_ip_on_launch = true
  tags = merge(
    var.tags,
    map(
      "project", var.project,
      "environment", var.environment
    )
  )
}

resource "aws_subnet" "public_subnet3" {
  vpc_id     = aws_vpc.FIQ_VPC.id
  cidr_block = var.PublicSubnetCidr_Blocks[2]
  availability_zone = var.availability_zones[2]
  map_public_ip_on_launch = true
  tags = merge(
    var.tags,
    map(
      "project", var.project,
      "environment", var.environment
    )
  )
}

# Create three private subnet
resource "aws_subnet" "private_subnet1" {
  vpc_id     = aws_vpc.FIQ_VPC.id
  cidr_block = var.PrivateSubnetCidr_Blocks[0]
  availability_zone = var.availability_zones[0]
  tags = merge(
    var.tags,
    map(
      "project", var.project,
      "environment", var.environment
    )
  )
}

resource "aws_subnet" "private_subnet2" {
  vpc_id     = aws_vpc.FIQ_VPC.id
  cidr_block = var.PrivateSubnetCidr_Blocks[1]
  availability_zone = var.availability_zones[1]
  tags = merge(
    var.tags,
    map(
      "project", var.project,
      "environment", var.environment
    )
  )
}

resource "aws_subnet" "private_subnet3" {
  vpc_id     = aws_vpc.FIQ_VPC.id
  cidr_block = var.PrivateSubnetCidr_Blocks[2]
  availability_zone = var.availability_zones[2]
  tags = merge(
    var.tags,
    map(
      "project", var.project,
      "environment", var.environment
    )
  )
}

# Create Elastic IP for NAT Gateway
#resource "aws_eip" "nat_gateway_EIP" {
#  vpc = true
#  tags = merge(
#    var.tags,
#    map(
#      "project", var.project,
#      "environment", var.environment
#    )
#  )
#}

# Create a NAT Gateway
resource "aws_nat_gateway" "FIQ_nat" {
  depends_on = [aws_internet_gateway.FIQ_IG]
#  allocation_id = aws_eip.nat_gateway_EIP.id
  allocation_id = "eipalloc-df09fae2"
  subnet_id = aws_subnet.public_subnet1.id
  tags = merge(
    var.tags,
    map(
      "project", var.project,
      "environment", var.environment
    )
  )
}

# Create Public Route Table
resource "aws_route_table" "public_routetable" {
  vpc_id = aws_vpc.FIQ_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.FIQ_IG.id
  }
  tags = merge(
    var.tags,
    map(
      "project", var.project,
      "environment", var.environment
    )
  )
}

# Create Private Route Table
resource "aws_route_table" "private_routetable" {
  depends_on = [
    aws_nat_gateway.FIQ_nat
  ]
  vpc_id = aws_vpc.FIQ_VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.FIQ_nat.id
  }
  tags = merge(
    var.tags,
    map(
      "project", var.project,
      "environment", var.environment
    )
  )
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_routetable.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_routetable.id
}

resource "aws_route_table_association" "public3" {
  subnet_id      = aws_subnet.public_subnet3.id
  route_table_id = aws_route_table.public_routetable.id
}

# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private_routetable.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private_routetable.id
}

resource "aws_route_table_association" "private3" {
  subnet_id      = aws_subnet.private_subnet3.id
  route_table_id = aws_route_table.private_routetable.id
}

# Public NACL
resource "aws_network_acl" "PublicNACL" {
  vpc_id = aws_vpc.FIQ_VPC.id
  subnet_ids = [
      aws_subnet.public_subnet1.id,aws_subnet.public_subnet2.id,aws_subnet.public_subnet3.id
  ]
  egress {
    protocol   = "-1"  #All Traffic
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  ingress {
    protocol   = "-1"  #All Traffic
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  tags = merge(
    var.tags,
    map(
      "project", var.project,
      "environment", var.environment
    )
  )
}

# Private NACL
resource "aws_network_acl" "PrivateNACL" {
  vpc_id = aws_vpc.FIQ_VPC.id
  subnet_ids = [
     aws_subnet.private_subnet1.id,aws_subnet.private_subnet2.id,aws_subnet.private_subnet3.id
  ]
  egress {
    protocol   = "-1" #All Traffic
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  ingress {
    protocol   = "-1" #All Traffic
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  tags = merge(
    var.tags,
    map(
      "project", var.project,
      "environment", var.environment
    )
  )
}
