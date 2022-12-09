resource "aws_instance" "ec_1"{
  instance_type = var.my-instance-type
  key_name = "madhur-docker"
  ami = "ami-0ada6d94f396377f2"
  tags = {
    Name = "Private-vpc-1(1)"
  }
  subnet_id = "${var.ec2_subnet_id_1}"
  security_groups = ["${var.security_id}"]
  user_data = var.user_data
  associate_public_ip_address = false
}

resource "aws_instance" "ec_2_efs"{
  instance_type = var.my-instance-type
  key_name = "madhur-docker"
  ami = "ami-0ada6d94f396377f2"
  tags = {
    Name = "Private-vpc-1(2)"
  }
  user_data = var.user_data
  subnet_id = "${var.ec2_subnet_id_2}"
  security_groups = ["${var.security_id}"]
  associate_public_ip_address = false
}


resource "null_resource" "local22" {
 
                
 connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("madhur-docker.pem")
    host     =  aws_instance.ec_2_efs.private_ip
    bastion_host = aws_instance.ec_4.public_ip
  }
 provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install nfs-common -y",
      "sudo apt update -y",
      "sudo apt install nfs-common -y",
      "sudo mkdir efs-1",
      "sudo mount -t nfs4 ${var.efs_mount_ip}:/ efs-1"
      
    ]
  }
}


resource "aws_instance" "ec_3"{
  instance_type = var.my-instance-type
  key_name = "madhur-docker"
  ami = "ami-0ada6d94f396377f2"
  tags = {
    Name = "Private-vpc-2(1)"
  }
  user_data = var.user_data
  subnet_id = "${var.ec2_subnet_id_3}"
  security_groups = ["${var.security_id_2}"]
  associate_public_ip_address = false
}

resource "aws_instance" "ec_4"{
  instance_type = var.my-instance-type
  key_name = "madhur-docker"
  ami = "ami-0ada6d94f396377f2"
  tags = {
    Name = "Public-vpc-1(1)"
  }
  subnet_id = "${var.ec2_subnet_id_1_public}"
  security_groups = ["${var.security_id}"]
  user_data = var.user_data
  associate_public_ip_address = true
  provisioner "file" {
    source = "madhur-docker.pem"
    destination = "/home/ubuntu/madhur-docker.pem"
  }
  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("madhur-docker.pem")
    host     =  aws_instance.ec_4.public_ip
  }
}



# resource "tls_private_key" "key" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "aws_key_pair" "generated_key" {
#   key_name   = "ec2-efs-access-key"
#   public_key = tls_private_key.key.public_key_openssh
# }