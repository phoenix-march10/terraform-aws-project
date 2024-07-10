variable "image_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "target_group_arn" {
  type = string
}
