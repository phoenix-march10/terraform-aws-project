output "alb_arn" {
  value = aws_lb.webapp-alb.arn
}

# output "alb_target_group_arn" {
#   value = aws_lb_target_group.webapp-target-group.arn
# }

output "alb_2_arn" {
  value = aws_lb.webapp-alb-2.arn
}

output "alb_2_target_group_arn" {
  value = aws_lb_target_group.webapp-target-group_2.arn
}
