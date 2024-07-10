output "asg_name" {
  value = aws_autoscaling_group.webapp_asg.name
}

output "launch_template_id" {
  value = aws_launch_template.webapp_launch_template.id
}
