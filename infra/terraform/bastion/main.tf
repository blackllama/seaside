//
// Variables
//

variable "name" {
    type        = "string"
    description = "Project name that will be embedded into other identifiers. This is expected to be supplied by the calling module, rather in this one."
    default     = "aws-vpc"
}

variable "environment" {
    type        = "string"
    description = "Environment name that will be embedded into other identifiers. This is expected to be supplied by the calling module, rather than this one."
    default     = "my-region"
}

variable "aws-ec2-keypair-name" {
    type        = "string"
    description = "The keypair name for ssh access to the instance. e.g. seaside-keypair",
    default = "seaside-keypair"
}

variable "aws-ec2-security-group-ids" {
    type        = "list"
    description = "List of security groups to associate with the AWS EC2 instance."
    default     = []
}

variable "aws-ec2-subnet-id" {
    type        = "string"
    description = "The subnet to launch the instance in."
}

//
// Resources
//

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

resource "aws_instance" "bastion" {
    ami = "${data.aws_ami.ubuntu.id}"
    associate_public_ip_address = true
    instance_type = "t2.micro"
    key_name = "${var.aws-ec2-keypair-name}"
    subnet_id = "${var.aws-ec2-subnet-id}"
    vpc_security_group_ids = ["${var.aws-ec2-security-group-ids}"]
    
    tags {
        Name = "${var.name}-${var.environment}-bastion"
    }

    user_data = <<EOF
sudo apt-get update && sudo apt-get install postgresql-client-common postgresql-client --assume-yes

EOF
}

