##        vpc - 1

resource "aws_vpc" "vpc-1" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true #gives you an internal domain name
    enable_dns_hostnames = true #gives you an internal host name
    # enable_classiclink = false
    tags = {
      Name = "vpc-madhur-app-1"
    }
}


##        vpc - 2
resource "aws_vpc" "vpc-2" {
  cidr_block = "172.16.0.0/16"   
  enable_dns_support = true #gives you an internal domain name
  enable_dns_hostnames = true #gives you an internal host name
    # enable_classiclink = false
  tags = {
    Name = "vpc-madhur-app-2"
  }
}


####          subnet  public-1 vpc-1

resource "aws_subnet" "public-1" {
  vpc_id = aws_vpc.vpc-1.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-2a"
  tags = {
    "name" = "vpc-1-pub-1-terra"
  }
}

####          subnet  private-1 vpc-1
resource "aws_subnet" "private-1" {
  vpc_id = aws_vpc.vpc-1.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = false
  availability_zone = "us-east-2b"
  tags = {
    "name" = "vpc-1-pvt-1-terra"
  }
}

####          subnet  public-2 vpc-1

resource "aws_subnet" "public-2" {
  vpc_id = aws_vpc.vpc-1.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-2b"
  tags = {
    "name" = "vpc-1-pub-2-terra"
  }
}

resource "aws_subnet" "public-3" {
  vpc_id = aws_vpc.vpc-1.id
  cidr_block = "10.0.15.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-2c"
  tags = {
    "name" = "terra-vpc-1-pub-3"
  }
}


####          subnet  private-2 vpc-1
resource "aws_subnet" "private-2" {
  vpc_id = aws_vpc.vpc-1.id
  cidr_block = "10.0.4.0/24"
  map_public_ip_on_launch = false
  availability_zone = "us-east-2c"
  tags = {
    "name" = "terra-vpc-1-pvt-2"
  }
}




####          subnet  private-1 vpc-2
resource "aws_subnet" "subnet-private-1" {
  vpc_id = aws_vpc.vpc-2.id
  cidr_block = "172.16.0.0/24"
  map_public_ip_on_launch = false
  availability_zone = "us-east-2c"
  tags = {
    "name" = "terra-vpc-2-pvt-1"
  }
}

resource "aws_subnet" "subnet-public-1" {
  vpc_id = aws_vpc.vpc-2.id
  cidr_block = "172.16.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-2b"
  tags = {
    "name" = "terra-vpc-2-pub-1"
  }
}

resource "aws_subnet" "subnet-public-2" {
  vpc_id = aws_vpc.vpc-2.id
  cidr_block = "172.16.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-2a"
  tags = {
    "name" = "terra-vpc-2-pub-2"
  }
}



####              aws-route_table      aws-rt
resource "aws_route_table" "aws-rt-public" {
  vpc_id = aws_vpc.vpc-1.id
  tags = {
    Name = "Vpc-1-rt-public"
  }
}

resource "aws_route_table" "aws-rt-private" {
  vpc_id = aws_vpc.vpc-1.id
  tags = {
    Name = "Vpc-1-rt-private"
  }
}


########          aws_route for aws-rt for vpc 1    for vpc peering at primary
resource "aws_route" "primary2secondary_public" {
  route_table_id = aws_route_table.aws-rt-public.id
  destination_cidr_block = "${aws_vpc.vpc-2.cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc_peer.id}"
}

resource "aws_route" "primary2secondarypublic_private" {
  route_table_id = aws_route_table.aws-rt-private.id
  destination_cidr_block = "${aws_vpc.vpc-2.cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc_peer.id}"
}


##########        aws_rt association   rt private vpc1
resource "aws_route_table_association" "rt_assoc_vpc1" {
  subnet_id      = aws_subnet.private-1.id
  route_table_id = aws_route_table.aws-rt-private.id
}

##########        aws_rt association private2   rt vpc1
resource "aws_route_table_association" "rt_assoc2_vpc1" {
  subnet_id      = aws_subnet.private-2.id
  route_table_id = aws_route_table.aws-rt-private.id
}

resource "aws_route_table_association" "rt_assoc_vpc_public" {
  subnet_id      = aws_subnet.public-1.id
  route_table_id = aws_route_table.aws-rt-public.id
}

##########        aws_rt association private2   rt vpc1
resource "aws_route_table_association" "rt_assoc2_vpc1_public" {
  subnet_id      = aws_subnet.public-2.id
  route_table_id = aws_route_table.aws-rt-public.id
}

resource "aws_route_table_association" "rt_assoc3_vpc1_public" {
  subnet_id      = aws_subnet.public-3.id
  route_table_id = aws_route_table.aws-rt-public.id
}



######              route table aws-rt-2
resource "aws_route_table" "aws-rt-2-private" {
  vpc_id = aws_vpc.vpc-2.id
  tags = {
    Name = "Vpc-2-rt-private"
  }
}

resource "aws_route_table" "aws-rt-2-public" {
  vpc_id = aws_vpc.vpc-2.id
  tags = {
    Name = "Vpc-2-rt-public"
  }
}


#    aws_route for rt-2 for vpc2  at secondary
resource "aws_route" "secondary2primary-private" {
  # ID of VPC 1 main route table.
  route_table_id = aws_route_table.aws-rt-2-private.id

  # CIDR block / IP range for VPC 2.
  destination_cidr_block = "${aws_vpc.vpc-1.cidr_block}"

  # ID of VPC peering connection.
  vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc_peer.id}"
}

resource "aws_route" "secondary2primary-public" {
  # ID of VPC 1 main route table.
  route_table_id = aws_route_table.aws-rt-2-public.id

  # CIDR block / IP range for VPC 2.
  destination_cidr_block = "${aws_vpc.vpc-1.cidr_block}"

  # ID of VPC peering connection.
  vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc_peer.id}"
}


####       aws_rta     rt-assocvpc for vpc2 private ip1
resource "aws_route_table_association" "rt_assoc1_vpc2" {
  subnet_id      = aws_subnet.subnet-private-1.id
  route_table_id = aws_route_table.aws-rt-2-private.id
}

resource "aws_route_table_association" "rt_assoc2_vpc2" {
  subnet_id      = aws_subnet.subnet-public-1.id
  route_table_id = aws_route_table.aws-rt-2-public.id
}

resource "aws_route_table_association" "rt_assoc3_vpc2" {
  subnet_id      = aws_subnet.subnet-public-2.id
  route_table_id = aws_route_table.aws-rt-2-public.id
}


resource "aws_vpc_peering_connection" "vpc_peer" {
  // This is necessary because DB instances are in separate VPC
  vpc_id        = aws_vpc.vpc-1.id
  peer_vpc_id   = aws_vpc.vpc-2.id
  auto_accept = true
  accepter {
    allow_remote_vpc_dns_resolution = false
  }
  requester {
    allow_remote_vpc_dns_resolution = false
  }
}


resource "aws_internet_gateway" "igw-vpc1" {
   vpc_id = aws_vpc.vpc-1.id
   tags = {
     Name = "igwforvpc-1"
   }
}

resource "aws_route" "route_igw_vpc1" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw-vpc1.id
  route_table_id = aws_route_table.aws-rt-public.id
}


resource "aws_internet_gateway" "igw-vpc2" {
   vpc_id = aws_vpc.vpc-2.id
   tags = {
     Name = "igwforvpc-2"
   }
}

resource "aws_route" "route_igw_vpc2" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw-vpc2.id
  route_table_id = aws_route_table.aws-rt-2-public.id
}


###   eip 

resource "aws_eip" "nat-gateway-eip"{
  depends_on = [
    aws_route_table_association.rt_assoc_vpc_public
  ]
  vpc = true
}

##     nat-gateway

resource "aws_nat_gateway" "nat-gateway-vpc-1" {
   depends_on = [
     aws_eip.nat-gateway-eip
   ]
   allocation_id = aws_eip.nat-gateway-eip.id
   subnet_id = aws_subnet.public-1.id
   tags = {
    Name = "Nat_gateway-vpc-1"
   }
}

resource "aws_route" "nat-gateway-private-route" {
   destination_cidr_block = "0.0.0.0/0"
   nat_gateway_id = aws_nat_gateway.nat-gateway-vpc-1.id
   route_table_id = aws_route_table.aws-rt-private.id
}



resource "aws_eip" "nat-gateway-eip-vpc-2"{
  depends_on = [
    aws_route_table_association.rt_assoc2_vpc2
  ]
  vpc = true
}

##     nat-gateway

resource "aws_nat_gateway" "nat-gateway-vpc-2" {
   depends_on = [
     aws_eip.nat-gateway-eip-vpc-2
   ]
   allocation_id = aws_eip.nat-gateway-eip-vpc-2.id
   subnet_id = aws_subnet.subnet-public-1.id
   tags = {
    Name = "Nat_gateway-vpc-2"
   }
}

resource "aws_route" "nat-gateway-private-route-2" {
   destination_cidr_block = "0.0.0.0/0"
   nat_gateway_id = aws_nat_gateway.nat-gateway-vpc-2.id
   route_table_id = aws_route_table.aws-rt-2-private.id
}