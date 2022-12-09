

output "instance-1"{
    value = aws_instance.ec_1.id
}

output "instance-2"{
    value = aws_instance.ec_2_efs.id
}

output "instance-3"{
    value = aws_instance.ec_3.id
}

output "instance-private-1"{
    value = aws_instance.ec_1.private_ip
}

output "instance-private-2" {
  value = aws_instance.ec_2_efs.private_ip
}

output "instance-private-3" {
  value = aws_instance.ec_3.private_ip
}

output "instance-private-4" {
  value = aws_instance.ec_4.private_ip
}