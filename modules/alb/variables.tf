variable "vpc_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "target_group_arn" {
  type = string
}
