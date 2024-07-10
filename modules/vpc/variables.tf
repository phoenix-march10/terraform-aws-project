variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "vpc_name" {
  description = "The name tag for the VPC"
  type        = string
  default     = "Webapp-VPC"
}

variable "subnet_2a_cidr_block" {
  description = "The CIDR block for subnet 2a"
  type        = string
  default     = "10.10.0.0/24"
}

variable "subnet_2b_cidr_block" {
  description = "The CIDR block for subnet 2b"
  type        = string
  default     = "10.10.1.0/24"
}

variable "availability_zone_2a" {
  description = "The availability zone for subnet 2a"
  type        = string
  default     = "us-east-2a"
}

variable "availability_zone_2b" {
  description = "The availability zone for subnet 2b"
  type        = string
  default     = "us-east-2b"
}

variable "key_name" {
  description = "The name of the key pair"
  type        = string
  default     = "webapp-key"
}

variable "public_key" {
  description = "The public key for the key pair"
  type        = string
}

variable "security_group_name" {
  description = "The name of the security group"
  type        = string
  default     = "allow_22_80"
}

variable "security_group_description" {
  description = "The description of the security group"
  type        = string
  default     = "Allow TLS inbound traffic 22 and 80"
}

variable "subnet_2a_name" {
  description = "The name tag for subnet 2a"
  type        = string
  default     = "webapp-subnet-2a-public"
}

variable "subnet_2b_name" {
  description = "The name tag for subnet 2b"
  type        = string
  default     = "webapp-subnet-2b-public"
}

variable "internet_gateway_name" {
  description = "The name tag for the internet gateway"
  type        = string
  default     = "Webapp-IGW"
}

variable "public_route_table_name" {
  description = "The name tag for the public route table"
  type        = string
  default     = "Webapp-public-RT"
}

variable "private_route_table_name" {
  description = "The name tag for the private route table"
  type        = string
  default     = "Webapp-private-RT"
}

variable "target_group_name" {
  description = "The name tag for the target group"
  type        = string
  default     = "webapp-target-group"
}
