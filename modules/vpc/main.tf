resource "aws_vpc" "vpc" {
  cidr_block           = "${lookup(var.vpc_cidr_block, var.env)}"
  enable_dns_hostnames = "true"

  tags = {
    Name = "${var.env}-vpc"
  }
}

resource "aws_subnet" "pub_sub1" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${lookup(var.pub_sub1_cidr_block, var.env)}"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "${var.env}-pub-sub-1a-1.0"
  }
}

resource "aws_subnet" "pub_sub2" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${lookup(var.pub_sub2_cidr_block, var.env)}"
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "${var.env}-pub-sub-1b-2.0"
  }
}

resource "aws_subnet" "app_sub1" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${lookup(var.app_sub1_cidr_block, var.env)}"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "${var.env}-app-sub-1a-3.0"
  }
}

resource "aws_subnet" "app_sub2" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${lookup(var.app_sub2_cidr_block, var.env)}"
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "${var.env}-app-sub-1b-4.0"
  }
}

resource "aws_subnet" "db_sub1" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${lookup(var.db_sub1_cidr_block, var.env)}"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = "${lookup(var.db_public_access, var.env)}"

  tags = {
    Name = "${var.env}-db-sub-1a-5.0"
  }
}

resource "aws_subnet" "db_sub2" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${lookup(var.db_sub2_cidr_block, var.env)}"
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = "${lookup(var.db_public_access, var.env)}"

  tags = {
    Name = "${var.env}-db-sub-1b-6.0"
  }
}



resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "${var.env}-igw"
  }
}

resource "aws_eip" "nat_eip" {
  vpc = "true"
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = "${aws_eip.nat_eip.id}"
  subnet_id     = "${aws_subnet.pub_sub1.id}"

  tags = {
    Name = "${var.env}-ng"
  }
}

resource "aws_route_table" "pub_rtb" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = {
    Name = "pub-rtb"
  }
}

resource "aws_route_table" "app_rtb" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.nat_gw.id}"
  }

  tags = {
    Name = "app-rtb"
  }
}

resource "aws_route_table_association" "pub_sub1_rtb_assoc" {
  subnet_id      = "${aws_subnet.pub_sub1.id}"
  route_table_id = "${aws_route_table.pub_rtb.id}"
}

resource "aws_route_table_association" "pub_sub2_rtb_assoc" {
  subnet_id      = "${aws_subnet.pub_sub2.id}"
  route_table_id = "${aws_route_table.pub_rtb.id}"
}

resource "aws_route_table_association" "app_sub1_rtb_assoc" {
  subnet_id      = "${aws_subnet.app_sub1.id}"
  route_table_id = "${aws_route_table.app_rtb.id}"
}

resource "aws_route_table_association" "app_sub2_rtb_assoc" {
  subnet_id      = "${aws_subnet.app_sub2.id}"
  route_table_id = "${aws_route_table.app_rtb.id}"
}

resource "aws_network_acl" "pub_nacl" {
  vpc_id = "${aws_vpc.vpc.id}"
  subnet_ids = [
    "${aws_subnet.pub_sub1.id}",
    "${aws_subnet.pub_sub2.id}"
  ]

  ingress {
    rule_no    = "100"
    protocol   = "tcp"
    from_port  = "80"
    to_port    = "80"
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }
  ingress {
    rule_no    = "200"
    protocol   = "tcp"
    from_port  = "443"
    to_port    = "443"
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }
  ingress {
    rule_no    = "300"
    protocol   = "tcp"
    from_port  = "22"
    to_port    = "22"
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }
  ingress {
    rule_no    = "400"
    protocol   = "icmp"
    from_port  = "0"
    to_port    = "0"
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }
  ingress {
    rule_no    = "500"
    protocol   = "tcp"
    from_port  = "5044"
    to_port    = "5044"
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }
  ingress {
    rule_no    = "600"
    protocol   = "tcp"
    from_port  = "5061"
    to_port    = "5061"
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }
  ingress {
    rule_no    = "700"
    protocol   = "tcp"
    from_port  = "9200"
    to_port    = "9200"
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }
  ingress {
    rule_no    = "800"
    protocol   = "udp"
    from_port  = "1194"
    to_port    = "1194"
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }
  ingress {
    rule_no    = "900"
    protocol   = "tcp"
    from_port  = "1024"
    to_port    = "65535"
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }
  ingress {
    rule_no    = "1000"
    protocol   = "udp"
    from_port  = "1024"
    to_port    = "65535"
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }

  egress {
    rule_no    = "100"
    protocol   = "tcp"
    from_port  = "80"
    to_port    = "80"
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }
  egress {
    rule_no    = "200"
    protocol   = "tcp"
    from_port  = "443"
    to_port    = "443"
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }
  egress {
    rule_no    = "300"
    protocol   = "tcp"
    from_port  = "22"
    to_port    = "22"
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }
  egress {
    rule_no    = "400"
    protocol   = "icmp"
    from_port  = "0"
    to_port    = "0"
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }
  egress {
    rule_no    = "500"
    protocol   = "tcp"
    from_port  = "5044"
    to_port    = "5044"
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }
  egress {
    rule_no    = "600"
    protocol   = "tcp"
    from_port  = "5061"
    to_port    = "5061"
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }
  egress {
    rule_no    = "700"
    protocol   = "tcp"
    from_port  = "9200"
    to_port    = "9200"
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }
  egress {
    rule_no    = "800"
    protocol   = "udp"
    from_port  = "1194"
    to_port    = "1194"
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }
  egress {
    rule_no    = "900"
    protocol   = "tcp"
    from_port  = "1024"
    to_port    = "65535"
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }
  egress {
    rule_no    = "1000"
    protocol   = "udp"
    from_port  = "1024"
    to_port    = "65535"
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }

  tags = {
    Name = "${var.env}-pub-nacl"
  }
}

resource "aws_network_acl" "app_nacl" {
  vpc_id = "${aws_vpc.vpc.id}"
  subnet_ids = [
    "${aws_subnet.app_sub1.id}",
    "${aws_subnet.app_sub2.id}"
  ]

  ingress {
    rule_no    = "100"
    protocol   = "tcp"
    from_port  = "80"
    to_port    = "80"
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }
  ingress {
    rule_no    = "200"
    protocol   = "tcp"
    from_port  = "443"
    to_port    = "443"
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }
  ingress {
    rule_no    = "300"
    protocol   = "tcp"
    from_port  = "22"
    to_port    = "22"
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }
  ingress {
    rule_no    = "400"
    protocol   = "icmp"
    from_port  = "0"
    to_port    = "0"
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }
  ingress {
    rule_no    = "500"
    protocol   = "tcp"
    from_port  = "1024"
    to_port    = "65535"
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }

  egress {
    rule_no    = "100"
    protocol   = "tcp"
    from_port  = "80"
    to_port    = "80"
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }
  egress {
    rule_no    = "200"
    protocol   = "tcp"
    from_port  = "443"
    to_port    = "443"
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }
  egress {
    rule_no    = "300"
    protocol   = "tcp"
    from_port  = "22"
    to_port    = "22"
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }
  egress {
    rule_no    = "400"
    protocol   = "icmp"
    from_port  = "0"
    to_port    = "0"
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }
  egress {
    rule_no    = "500"
    protocol   = "tcp"
    from_port  = "1024"
    to_port    = "65535"
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }

  tags = {
    Name = "${var.env}-app-nacl"
  }
}
