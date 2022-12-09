provider "aws" {
#   access_key            =   ""
#   secret_key            =   ""
  region                =   "us-east-2"
}



module alb{
    source                  =   "./Modules/alb"
    instance-1-private      =   module.ec2.instance-private-1
    instance-2-private2     =   module.ec2.instance-private-2
    instance-3-private-3    =   module.ec2.instance-private-3
    instance-4-private-4    =   module.ec2.instance-private-4
    vpc_id                  =   module.vpc.vpc_id_1
    vpc_id-2                =   module.vpc.vpc_id_2
    security_group          =   module.security_group.sec_gr_id
    security_group_2        =   module.security_group.sec_gr_id_2
    subnet_1_vpc_1          =   module.vpc.subnet_id_1_public_vpc_1
    subnet_2_vpc_1          =   module.vpc.subnet_id_3_public_vpc_1
    subnet_3_vpc_1          =   module.vpc.subnet_id_2_public_vpc_1
    
}

module vpc{
    source              =   "./Modules/vpc"
}

module security_group{
    source              =   "./Modules/securityGroup"
    vpc_id_sg           =    module.vpc.vpc_id_1
    vpc_id_sg_2         =    module.vpc.vpc_id_2
}

module efs{
    source               =    "./Modules/efs"
    subnet_id            =    module.vpc.subnet_id_2_private_vpc_1
    sg_id                =    module.security_group.sec_gr_id
    
}

module ec2{
   source                 =     "./Modules/ec2"
   security_id            =     module.security_group.sec_gr_id
   security_id_2          =     module.security_group.sec_gr_id_2
   ec2_subnet_id_1        =     module.vpc.subnet_id_1_private_vpc_1
   ec2_subnet_id_2        =     module.vpc.subnet_id_2_private_vpc_1
   ec2_subnet_id_3        =     module.vpc.subnet_id_1_private_vpc_2
   ec2_subnet_id_1_public =     module.vpc.subnet_id_1_public_vpc_1
   
   my-instance-type       =     "t2.micro"
   efs_mount_ip           =     module.efs.efs-ip
   user_data              =     "${file("user-data.tpl")}"
}