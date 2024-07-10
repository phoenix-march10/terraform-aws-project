# Create Launch Template
resource "aws_launch_template" "webapp_launch_template" {
  name          = "webapp_launch_template"
  image_id      = var.image_id
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [var.security_group_id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "webapp-machine-asg"
    }
  }

  user_data = filebase64("${path.root}/userdata.sh")
}

# Create Auto Scaling Group
resource "aws_autoscaling_group" "webapp_asg" {
  name_prefix         = "webapp-asg-"
  vpc_zone_identifier = var.subnets
  desired_capacity    = 2
  max_size            = 5
  min_size            = 2
  target_group_arns   = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.webapp_launch_template.id
    version = "$Latest"
  }
}
