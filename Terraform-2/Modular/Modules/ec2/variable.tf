variable "my-instance-type"{
    type = string
}

variable "ec2_subnet_id_1" {
  description = "subnt id-1"
}

variable "ec2_subnet_id_2" {
  description = "subnt id 1"
}

variable "ec2_subnet_id_3" {
  description = "subnt id 2"
}

variable security_id{
  description = "security-group"
}

variable security_id_2{
  description = "security-group-2"
}



variable "user_data"{
    description = "user-data"
}

variable "ec2_subnet_id_1_public" {
  description = "subnet public"
}


variable "efs_mount_ip" {
   description = "mounting ip add"
}