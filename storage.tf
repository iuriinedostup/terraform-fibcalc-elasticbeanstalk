resource "aws_db_instance" "complex_db" {
  identifier     = "complex-db"
  instance_class = "db.t2.micro"
  engine         = "postgres"
  engine_version = "12.2"

  name                   = "fibvalues"
  username               = "postgres"
  password               = "postgres"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.complex_rds.id]

  allocated_storage     = 5
  max_allocated_storage = 10

  availability_zone = "eu-west-1a"
  multi_az          = false

  tags = merge(var.default_tags, {
    Name = "Complex DB"
  })
}

resource "aws_elasticache_cluster" "complex_redis" {
  cluster_id           = "complex-redis"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis4.0"
  engine_version       = "4.0.10"
  port                 = 6379
  security_group_ids   = [aws_security_group.complex_redis.id]
  availability_zone    = "eu-west-1a"

  tags = merge(var.default_tags, {
    Name = "Complex Redis"
  })
}
