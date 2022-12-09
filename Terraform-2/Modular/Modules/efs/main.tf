resource "aws_efs_file_system" "myefs" {
  creation_token = "terraform-efs"
  tags = {
    Name = "terraform-efs"
  }
}


resource "aws_efs_mount_target" "alpha-1" {
  file_system_id  = aws_efs_file_system.myefs.id
  subnet_id       = var.subnet_id    #aws_subnet.private-1.id
  security_groups = ["${var.sg_id}"]
}
