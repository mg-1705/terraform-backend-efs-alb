resource "aws_lb_target_group" "tg" {
  name        = "TargetGroup"
  port        = 80
  target_type = "ip"
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  
}


resource "aws_alb_target_group_attachment" "tgattachment-1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = var.instance-1-private
  port = 80
  
}

resource "aws_alb_target_group_attachment" "tgattachment-2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = var.instance-2-private2
  port = 80
}

resource "aws_alb_target_group_attachment" "tgattachment-3" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = var.instance-3-private-3
  availability_zone = "us-east-2c"
  port = 80
}

resource "aws_alb_target_group_attachment" "tgattachment-4" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = var.instance-4-private-4
  port = 80
}

resource "aws_lb" "lb" {
  name               = "ALB-1"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${var.security_group}" ]
  subnets            = ["${var.subnet_1_vpc_1}","${var.subnet_3_vpc_1}","${var.subnet_2_vpc_1}"]
}



resource "aws_lb_listener" "front_end_1" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.tg.id
    type = "forward"
  }
}


####################################################
# Listener Rule
####################################################

resource "aws_lb_listener_rule" "static" {
  listener_arn = aws_lb_listener.front_end_1.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }

  condition {
    path_pattern {
      values = ["/var/www/html/index.html"]
    }
  }
}

