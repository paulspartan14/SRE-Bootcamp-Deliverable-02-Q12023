# --- SG FOR APLICATION LOAD BALANCER - MODULE ----
module "sg_alb" {
    source = "../modules/sg-instances"

    vpc_id = local.vpc_id
    instance_name = "alb-${local.instance_name}"

    sg_instances_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "port for nginx server"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "port for nginx server"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

# --- SG FORINSTANCE - MODULE ----
module "sg_instance" {
    source = "../modules/lb-instances"

    vpc_id = local.vpc_id
    instance_name = "instance-${local.instance_name}"
    sg_instances_rules = [
    {                                   
            rule                     = "http-8080-tcp"
            source_security_group_id = module.sg_alb.security_group_id
            description              = "allows access to app on specific port"
    }
  ]
}

# Terraform Module AWS Application Load Balancer (ALB)
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "5.16.0"

  name = "${local.instance_name}-alb"
  load_balancer_type = "application"
  vpc_id = local.vpc_id
  subnets = [ local.public_subnet_01_id , local.public_subnet_02_id ]
  security_groups = [module.sg_alb.security_group_id ]
    http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]  
  target_groups = [
    {
      name_prefix      = "app1-"
      backend_protocol = "HTTP"
      backend_port     = 8080
      target_type      = "instance"
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/_health"
        port                = 8080
        healthy_threshold   = 5
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200"
      }      
      protocol_version = "HTTP1"

    }     
  ]

}

resource "aws_launch_template" "template" {
  name = "capstone-server"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 8
    }
  }

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  credit_specification {
    cpu_credits = "standard"
  }

  image_id = local.instance_ami

  instance_type = "t2.micro"

  monitoring {
    enabled = true
  }

  vpc_security_group_ids = [ "${module.sg_instance.security_group_id}" ]
  tag_specifications {
    
    resource_type = "instance"

    tags = {
      Name = "capstone-server"
    }
  }

}

# -- creating autoscaling group - no module
resource "aws_autoscaling_group" "server-asg" {

  name_prefix = "capstone-server-asg-"

  vpc_zone_identifier  = [ local.public_subnet_01_id , local.public_subnet_02_id ]

  desired_capacity   = 1
  min_size           = 1
  max_size           = 4
  
  target_group_arns = module.alb.target_group_arns

  health_check_type = "EC2"

  launch_template {
    id      = aws_launch_template.template.id
    version = aws_launch_template.template.latest_version
  } 

}

## MONITORING ##
resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_up" { # IF CPU < 50% THEN ALARM
  alarm_name = "web_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "50"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.server-asg.name}"
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ "${aws_autoscaling_policy.web_policy_up.arn}" ]
}

resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_down" { # IF CPU > 30% THEN ALARM
  alarm_name = "web_cpu_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "30"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.server-asg.name}"
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ "${aws_autoscaling_policy.web_policy_down.arn}" ]
}

resource "aws_autoscaling_policy" "web_policy_up" {
  name = "web_policy_up"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = "${aws_autoscaling_group.server-asg.name}"
}

resource "aws_autoscaling_policy" "web_policy_down" {
  name = "web_policy_down"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = "${aws_autoscaling_group.server-asg.name}"
}