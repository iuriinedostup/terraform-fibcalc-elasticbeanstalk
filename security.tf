resource "aws_security_group" "complex_sg" {
  name = "complex-eb-sg"

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port   = 80
    protocol    = "TCP"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = var.vpc_id
  tags = merge(var.default_tags, {
    Name = "elasticbeanstalk-sg"
  })
}

resource "aws_security_group" "complex_rds" {
  name = "complex-rds-sg"
  ingress {
    from_port       = 5432
    protocol        = "TCP"
    to_port         = 5432
    security_groups = [aws_security_group.complex_sg.id]
  }
  vpc_id = var.vpc_id
  tags = merge(var.default_tags, {
    Name = "rds-sg"
  })
}

resource "aws_security_group" "complex_redis" {
  name = "complex-redis-sg"
  ingress {
    from_port       = 6379
    protocol        = "TCP"
    to_port         = 6379
    security_groups = [aws_security_group.complex_sg.id]
  }
  vpc_id = var.vpc_id
  tags = merge(var.default_tags, {
    Name = "redis-sg"
  })
}