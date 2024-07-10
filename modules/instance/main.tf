# Creating EC2 server/instance
resource "aws_instance" "webapp-instance-1-public" {
    ami = var.ami
    instance_type = var.instance_type
    subnet_id = var.subnet_id
    key_name = var.key_name
    associate_public_ip_address = true
    vpc_security_group_ids = var.security_group_ids
    user_data = filebase64("${path.root}/userdata.sh") # filebase64 will encode the content of userdata.sh

    tags = {
      Name = "Webapp-machine1-public"
    }
}

resource "aws_instance" "webapp-instance-2-public" {
    ami = var.ami
    instance_type = var.instance_type
    subnet_id = var.subnet_id
    key_name = var.key_name
    associate_public_ip_address = true
    vpc_security_group_ids = var.security_group_ids
    user_data = filebase64("${path.root}/userdata.sh") # filebase64 will encode the content of userdata.sh

    tags = {
      Name = "Webapp-machine2-public"
    }
}
