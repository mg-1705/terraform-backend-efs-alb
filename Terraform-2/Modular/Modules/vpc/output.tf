output "vpc_id_1"{
  value = "${aws_vpc.vpc-1.id}"
}

output "vpc_id_2"{
  value = "${aws_vpc.vpc-2.id}"
}

output "subnet_id_1_private_vpc_1"{
  value = "${aws_subnet.private-1.id}"
}

output "subnet_id_2_private_vpc_1"{
  value = "${aws_subnet.private-2.id}"
}

output "subnet_id_1_public_vpc_1"{
  value = "${aws_subnet.public-1.id}"
}

output "subnet_id_2_public_vpc_1"{
  value = "${aws_subnet.public-2.id}"
}


output "subnet_id_3_public_vpc_1"{
  value = "${aws_subnet.public-3.id}"
}

output "subnet_id_1_private_vpc_2"{
  value = "${aws_subnet.subnet-private-1.id}"
}


output "subnet_id_1_public_vpc_2"{
  value = "${aws_subnet.subnet-public-1.id}"
}

output "subnet_id_2_public_vpc_2"{
  value = "${aws_subnet.subnet-public-2.id}"
}