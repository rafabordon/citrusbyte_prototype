resource "aws_cloudwatch_metric_alarm" "service_high_cpu" {
  alarm_name          = "alarmAppCPUUtilizationHigh"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "60"

  dimensions {
    ClusterName = "cb-prototype-cluster"
    ServiceName = "cb-prototype"
  }

  alarm_actions = ["${aws_appautoscaling_policy.scale_out.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "service_low_cpu" {
  alarm_name          = "alarmAppCPUUtilizationLow"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "15"

  dimensions {
    ClusterName = "cb-prototype-cluster"
    ServiceName = "cb-prototype"
  }

  alarm_actions = ["${aws_appautoscaling_policy.scale_in.arn}"]
}

resource "aws_autoscaling_policy" "cb-clusters" {
  name                   = "cb-prototype-clusters"
  scaling_adjustment     = 4
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.cb-ecs-cluster.name}"
}

resource "aws_cloudwatch_metric_alarm" "cb-prototype-cluster" {
  alarm_name          = "cb-prototype-cluster-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.cb-ecs-cluster.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization for CB Prototype Clusters"
  alarm_actions     = ["${aws_autoscaling_policy.cb-clusters.arn}"]
}
