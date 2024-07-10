# Create Load Balancer
resource "aws_lb" "webapp-alb" {
  name               = "webapp-alb"
  internal           = false # false meaning, not internal use only, this load balancer should available over the internet, externally.
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_80.id] #check below security group configuratiin for LB
  subnets            = var.subnets

  tags = {
    Environment = "production"
  }
}

# create security group for load balancer
resource "aws_security_group" "allow_80" {
  name        = "allow_80"
  description = "Allow TLS inbound traffic 80"
  vpc_id      = var.vpc_id

  tags = {
    Name = "allow_80"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_80_1" {
  security_group_id = aws_security_group.allow_80.id
  cidr_ipv4         = "0.0.0.0/0" # All people to login from port 80 to 80
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_outbound_traffic_ipv4_1" {
  security_group_id = aws_security_group.allow_80.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports, no need to mention from_port and to_port with this single line
}

resource "aws_vpc_security_group_egress_rule" "allow_outbound_traffic_ipv6_1" {
  security_group_id = aws_security_group.allow_80.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Create Listener
resource "aws_lb_listener" "webapp_listener" {
  load_balancer_arn = aws_lb.webapp-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }
}


# Create ALB2 Target Group
resource "aws_lb_target_group" "webapp-target-group_2" {
  name     = "webapp-target-group-2"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

# Create ALB2 Load Balancer
resource "aws_lb" "webapp-alb-2" {
  name               = "webapp-alb-2"
  internal           = false # false meaning, not internal use only, this load balancer should available over the internet, externally.
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_80.id] #check below security group configuratiin for LB
  subnets            = var.subnets

  tags = {
    Environment = "production"
  }
}

# Create Listener
resource "aws_lb_listener" "webapp_listener_2" {
  load_balancer_arn = aws_lb.webapp-alb-2.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webapp-target-group_2.arn
  }
}
