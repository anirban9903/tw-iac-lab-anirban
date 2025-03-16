resource "aws_lb" "lb" {
  name               = "${var.prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [for subnet in aws_subnet.public_subnet : subnet.id]

  tags = {
    Name = "${var.prefix}-lb"
  }
}

resource "aws_lb_target_group" "tg" {
  name        = "${var.prefix}-tg"
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.anirban-iac-lab-vpc.id
  target_type = "ip"
  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200,302"
    path                = "/users"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }
  tags = {
    Name = "${var.prefix}-lb"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_security_group" "lb_sg" {
  name        = "${var.prefix}-lb_sg"
  description = "Security group for load balancer allowing external access on port 80 and internal access on 8000"
  vpc_id      = aws_vpc.anirban-iac-lab-vpc.id
  ingress {
    description = "Allow external access on port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow internal access on port 8000"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    self        = true
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.prefix}-lb_sg"
  }
}