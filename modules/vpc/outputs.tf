output "webapp_vpc_id" {
  value = aws_vpc.webapp-vpc.id
}

output "webapp_subnet_2a_public_id" {
  value = aws_subnet.webapp-subnet-2a-public.id
}

output "webapp_subnet_2b_public_id" {
  value = aws_subnet.webapp-subnet-2b-public.id
}

output "webapp_key_name" {
  value = aws_key_pair.webapp-key-new.key_name
}

output "allow_22_80_id" {
  value = aws_security_group.allow_22_80.id
}

output "webapp_target_group_arn" {
  value = aws_lb_target_group.webapp-target-group.arn
}
