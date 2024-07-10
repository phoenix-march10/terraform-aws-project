# Creating the VPC
resource "aws_vpc" "webapp-vpc" {
  cidr_block       = var.vpc_cidr_block

  tags = {
    Name = var.vpc_name
  }
}

# Creating 2 subnets
resource "aws_subnet" "webapp-subnet-2a-public" {
  vpc_id     = aws_vpc.webapp-vpc.id
  cidr_block = var.subnet_2a_cidr_block
  availability_zone = var.availability_zone_2a
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet_2a_name
  }
}

resource "aws_subnet" "webapp-subnet-2b-public" {
  vpc_id     = aws_vpc.webapp-vpc.id
  cidr_block = var.subnet_2b_cidr_block
  availability_zone = var.availability_zone_2b
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet_2b_name
  }
}

resource "aws_key_pair" "webapp-key" {
  key_name   = var.key_name
  public_key = var.public_key
}

# create security group
resource "aws_security_group" "allow_22_80" {
  name        = var.security_group_name
  description = var.security_group_description
  vpc_id      = aws_vpc.webapp-vpc.id

  tags = {
    Name = var.security_group_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_22" {
  security_group_id = aws_security_group.allow_22_80.id
  cidr_ipv4         = "0.0.0.0/0" # All people to login from port 22 to 22
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_80" {
  security_group_id = aws_security_group.allow_22_80.id
  cidr_ipv4         = "0.0.0.0/0" # All people to login from port 22 to 22
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_outbound_traffic_ipv4" {
  security_group_id = aws_security_group.allow_22_80.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports, no need to mention from_port and to_port with this single line
}

resource "aws_vpc_security_group_egress_rule" "allow_outbound_traffic_ipv6" {
  security_group_id = aws_security_group.allow_22_80.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Create Internet Gateway
resource "aws_internet_gateway" "webapp-igw" {
  vpc_id = aws_vpc.webapp-vpc.id

  tags = {
    Name = var.internet_gateway_name
  }
}

# Create Route Table Public
resource "aws_route_table" "webapp-public-RT" {
  vpc_id = aws_vpc.webapp-vpc.id

  route {
    cidr_block = "0.0.0.0/0" # all the traffic allows(public) and forwarded to the IGW
    gateway_id = aws_internet_gateway.webapp-igw.id
  }

  tags = {
    Name = var.public_route_table_name
  }
}

resource "aws_route_table" "webapp-private-RT" {
  vpc_id = aws_vpc.webapp-vpc.id

  tags = {
    Name = var.private_route_table_name
  }
}


# Attach Route table to the public subnet
resource "aws_route_table_association" "RT_association_subnet_1_public" {
  subnet_id      = aws_subnet.webapp-subnet-2a-public.id
  route_table_id = aws_route_table.webapp-public-RT.id
}

resource "aws_route_table_association" "RT_association_subnet_2_public" {
  subnet_id      = aws_subnet.webapp-subnet-2b-public.id
  route_table_id = aws_route_table.webapp-public-RT.id
}

# Create Target Group
resource "aws_lb_target_group" "webapp-target-group" {
  name     = var.target_group_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.webapp-vpc.id
}
