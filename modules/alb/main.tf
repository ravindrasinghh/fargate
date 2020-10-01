resource "aws_lb" "alb" {
  name               = "${var.env}-ops-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.alb_sg.id}"]
  subnets            = ["${var.pub_sub1_id}", "${var.pub_sub2_id}"]

  enable_deletion_protection = false

  tags = {
    Environment = "${var.env}"
  }
}

resource "aws_lb_target_group" "my-tg" {
  name        = "${var.env}-target-group-ops"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = "${var.vpc_id}"
  depends_on  = [aws_lb.alb]
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = "${aws_lb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"
  default_action {
  type             = "forward"
  target_group_arn = "${aws_lb_target_group.my-tg.arn}"
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.env}-alb-sg"
  description = "Security group for prod alb"
  vpc_id      = "${var.vpc_id}"
  tags = {
    Name = "${var.env}-elb-sg"
  }

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
