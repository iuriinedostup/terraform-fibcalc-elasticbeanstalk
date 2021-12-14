resource "aws_iam_role" "eb_service_role" {
  assume_role_policy = data.aws_iam_policy_document.eb-service-role-policy.json
  tags = merge(var.default_tags, {
    Name = "service role"
  })
  name = "eb-service-role"
}

data "aws_iam_policy_document" "eb-service-role-policy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    effect = "Allow"
    principals {
      identifiers = ["elasticbeanstalk.amazonaws.com"]
      type = "Service"
    }
  }
}


resource "aws_iam_policy_attachment" "eb_service_default" {
  name = "eb-service-default"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
  roles = [aws_iam_role.eb_service_role.id]
}

resource "aws_iam_policy_attachment" "eb_service_health" {
  name = "eb-service-health"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
  roles = [aws_iam_role.eb_service_role.id]
}

resource "aws_iam_instance_profile" "eb_instance_profile" {
  name = "eb-ec2-instance-profile"
  role = aws_iam_role.eb_ec2_role.name
}

# EC2 Role
resource "aws_iam_role" "eb_ec2_role" {
  assume_role_policy = data.aws_iam_policy_document.eb-ec2-role-policy.json
  name = "eb-ec2-role"
  tags = merge(var.default_tags, {
    Name = "ec2 role"
  })
}

data "aws_iam_policy_document" "eb-ec2-role-policy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    effect = "Allow"
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type = "Service"
    }
  }
}

resource "aws_iam_policy_attachment" "eb_ec2_web" {
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
  name = "eb-ec2-container"
  roles = [aws_iam_role.eb_ec2_role.id]
}

resource "aws_iam_policy_attachment" "eb_ec2_worker" {
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
  name = "eb-ec2-container"
  roles = [aws_iam_role.eb_ec2_role.id]
}

resource "aws_iam_policy_attachment" "eb_ec2_docker" {
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
  name = "eb-ec2-container"
  roles = [aws_iam_role.eb_ec2_role.id]
}