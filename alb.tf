# Security Group
resource "aws_security_group" "ec2-web-sg" {
  vpc_id = aws_vpc.project-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = var.egress_cidr_blocks
  }
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = var.ingress_ssh_cidr_blocks
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.ingress_http_cidr_blocks
  }
    ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.ingress_http_cidr_blocks
  }
  tags = {
    Name = "ssh-allowed"
  }
}

resource "aws_security_group" "alb-web-sg" {
  vpc_id = aws_vpc.project-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = var.egress_cidr_blocks
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.ingress_http_cidr_blocks
  }
    ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.ingress_http_cidr_blocks
  }
  tags = {
    Name = "ssh-allowed"
  }
}

# Create ec2 instances
resource "aws_instance" "web-1" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_subnet_us_east_1a.id
  vpc_security_group_ids = [aws_security_group.ec2-web-sg.id]
  user_data              = file(var.bootstrap-web)
  key_name               = var.key_name
  depends_on = [aws_nat_gateway.nat-gateway-1a, aws_route_table.private_route_table_us_east_1a, aws_route_table_association.private-route-table-assoc-us-east-1b]

  tags = {
    Name = "Web_1-terraform"
  }
}


resource "aws_instance" "web-2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_subnet_us_east_1b.id
  vpc_security_group_ids = [aws_security_group.ec2-web-sg.id]
  user_data              = file(var.bootstrap-web)
  key_name               = var.key_name
  depends_on = [aws_nat_gateway.nat-gateway-1a, aws_route_table.private_route_table_us_east_1a, aws_route_table_association.private-route-table-assoc-us-east-1b]

  tags = {
    Name = "Web_2-terraform"
  }
}

resource "aws_instance" "troubleshooting-machine" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet_us_east_1a.id
  vpc_security_group_ids = [aws_security_group.ec2-web-sg.id]
  key_name               = var.key_name

  tags = {
    Name = "troubleshooting-machine"
  }
}


# Application Load Balancer

resource "aws_alb" "project-alb" {
  name               = "project-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ec2-web-sg.id]
  subnets            = [aws_subnet.public_subnet_us_east_1a.id, aws_subnet.public_subnet_us_east_1b.id]
  depends_on         = [aws_internet_gateway.project-igw]
  tags = {
    Name = "project-alb"
  }
}

# Target Groups

resource "aws_lb_target_group" "project-target-group" {
  name     = "project-target-group"
  port     = var.tg_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.project-vpc.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "project-target-group"
  }
}

resource "aws_lb_target_group_attachment" "web-1" {
  target_group_arn = aws_lb_target_group.project-target-group.arn
  target_id        = aws_instance.web-1.id
  port             = var.tg_port
}

resource "aws_lb_target_group_attachment" "web-2" {
  target_group_arn = aws_lb_target_group.project-target-group.arn
  target_id        = aws_instance.web-2.id
  port             = var.tg_port
}

# Listener

resource "aws_lb_listener" "project-listener" {
  load_balancer_arn = aws_alb.project-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.project-target-group.arn
  }
}
