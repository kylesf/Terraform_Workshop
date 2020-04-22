resource "aws_lb" "main_lb" {
  name               = "main-loadbalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer_security_group.id]
  subnets            = [aws_subnet.Public_webserver_zone_a.id, aws_subnet.Public_webserver_zone_b.id]
}

resource "aws_alb_target_group" "alb_front_http_webservers" {
  name     = "alb-front-http"
  vpc_id   = aws_vpc.VPC.id
  port     = "80"
  protocol = "HTTP"
}

resource "aws_alb_target_group_attachment" "alb_webserver_a_http" {
  target_group_arn = aws_alb_target_group.alb_front_http_webservers.arn
  target_id        = aws_instance.webserver_a.id
  port             = 80
}

resource "aws_alb_target_group_attachment" "alb_webserver_b_http" {
  target_group_arn = aws_alb_target_group.alb_front_http_webservers.arn
  target_id        = aws_instance.webserver_b.id
  port             = 80
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.main_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.alb_front_http_webservers.arn
    type             = "forward"
  }
}
