terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "s3-bucket-terrform-infra-code"
    key    = "terraform-state.tfstate"
    region = "us-east-2"
  }

}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}

# Reference the VPC module
module "tf-module-vpc" {
  source = "./modules/vpc"
  public_key = var.public_key
}

# Reference the ALB module
module "tf-module-alb" {
  source = "./modules/alb"
  vpc_id = module.tf-module-vpc.webapp_vpc_id
  subnets = [
    module.tf-module-vpc.webapp_subnet_2a_public_id,
    module.tf-module-vpc.webapp_subnet_2b_public_id
  ]
  target_group_arn = module.tf-module-vpc.webapp_target_group_arn
}

# Reference the first instance module
module "tf-module-instance-1" {
  source = "./modules/instance"
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = module.tf-module-vpc.webapp_subnet_2a_public_id
  key_name = module.tf-module-vpc.webapp_key_name
  security_group_ids = [module.tf-module-vpc.allow_22_80_id]
}

# Reference the second instance module
module "tf-module-instance-2" {
  source = "./modules/instance"
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = module.tf-module-vpc.webapp_subnet_2b_public_id
  key_name = module.tf-module-vpc.webapp_key_name
  security_group_ids = [module.tf-module-vpc.allow_22_80_id]
}


# Reference the ASG module
module "tf-module-asg" {
  source = "./modules/asg"
  image_id = var.ami
  instance_type = var.instance_type
  key_name = module.tf-module-vpc.webapp_key_name
  security_group_id = module.tf-module-vpc.allow_22_80_id
  subnets = [
    module.tf-module-vpc.webapp_subnet_2a_public_id,
    module.tf-module-vpc.webapp_subnet_2b_public_id
  ]
  target_group_arn = module.tf-module-vpc.webapp_target_group_arn
}


# Create Target Group attachment
resource "aws_lb_target_group_attachment" "webapp-target-group-attachment1" {
  target_group_arn = module.tf-module-vpc.webapp_target_group_arn
  target_id        = module.tf-module-instance-1.webapp_instance_1_public_id
  port             = 80
}

resource "aws_lb_target_group_attachment" "webapp-target-group-attachment2" {
  target_group_arn = module.tf-module-vpc.webapp_target_group_arn
  target_id        = module.tf-module-instance-2.webapp_instance_2_public_id
  port             = 80
}