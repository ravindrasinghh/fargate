resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.env}-ecs"
}


resource "aws_ecs_task_definition" "service" {
  family                   = "${var.env}-defination"
  requires_compatibilities = ["FARGATE"]
  container_definitions    = "${file("taskdefination.json")}"
  cpu                      =  512
  execution_role_arn       = "${var.role_arn}"
  task_role_arn            = "${var.task_role_arn}"
  network_mode             = "awsvpc"
  memory                   = 1024
}

resource "aws_ecs_service" "ecs-service" {
  name            = "${var.env}-service"
  cluster         = "${aws_ecs_cluster.ecs-cluster.id}"
  task_definition = "${aws_ecs_task_definition.service.arn}"
  launch_type     = "FARGATE"
  desired_count   = 2

  # iam_role        = "${var.role_arn}"
  load_balancer {
    elb_name         = ""
    target_group_arn = "${var.tg_arn}"
    container_name   = "${var.container_name}"
    container_port   = 80
  }
  network_configuration {
    subnets         = ["${var.app_sub1_id}", "${var.app_sub2_id}"]
    security_groups = ["${aws_security_group.service_sg.id}"]

  }
}

resource "aws_security_group" "service_sg" {
  name        = "${var.env}-service-sg"
  description = "Security group for ${var.env} alb"
  vpc_id      = "${var.vpc_id}"
  tags = {
    Name = "${var.env}-service-sg"
  }
  ingress {
    from_port   = "80"
    to_port     = "80"
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
