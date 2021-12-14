resource "aws_elastic_beanstalk_application" "udemy_multidocker" {
  name = "multi-docker-app"
  tags = merge(var.default_tags, {
    Name = "EB App"
  })

  appversion_lifecycle {
    service_role          = aws_iam_role.eb_service_role.arn
    max_count             = 3
    delete_source_from_s3 = true
  }
}

resource "aws_elastic_beanstalk_environment" "udemy_multidocer_env" {
  application         = aws_elastic_beanstalk_application.udemy_multidocker.name
  name                = "multi-docker-env"
  tags                = var.default_tags
  solution_stack_name = "64bit Amazon Linux 2 v3.4.9 running Docker"

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", var.subnets)
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = join(",", var.subnets)
  }
  setting {
    name      = "EnableSpot"
    namespace = "aws:ec2:instances"
    value     = true
  }
  setting {
    name      = "InstanceTypes"
    namespace = "aws:ec2:instances"
    value     = "t2.medium, t2.small"
  }

  setting {
    name      = "ServiceRole"
    namespace = "aws:elasticbeanstalk:environment"
    value     = aws_iam_role.eb_service_role.arn
  }

  setting {
    name      = "IamInstanceProfile"
    namespace = "aws:autoscaling:launchconfiguration"
    value     = aws_iam_instance_profile.eb_instance_profile.arn
  }

  setting {
    name      = "SecurityGroups"
    namespace = "aws:autoscaling:launchconfiguration"
    value     = aws_security_group.complex_sg.id
  }
  setting {
    name      = "ManagedSecurityGroup"
    namespace = "aws:elb:loadbalancer"
    value     = aws_security_group.complex_sg.id
  }

  setting {
    name      = "SecurityGroups"
    namespace = "aws:elb:loadbalancer"
    value     = aws_security_group.complex_sg.id
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "REDIS_HOST"
    value     = aws_elasticache_cluster.complex_redis.cache_nodes[0].address
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "REDIS_PORT"
    value     = aws_elasticache_cluster.complex_redis.cache_nodes[0].port
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PG_HOST"
    value     = aws_db_instance.complex_db.address
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PG_PORT"
    value     = aws_db_instance.complex_db.port
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PG_NAME"
    value     = aws_db_instance.complex_db.name
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PG_PASS"
    value     = aws_db_instance.complex_db.password
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PG_USER"
    value     = aws_db_instance.complex_db.username
  }
}