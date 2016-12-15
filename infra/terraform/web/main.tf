//
// Variables
//

variable "name" {
    type        = "string"
    description = "The name of your stack, e.g. seaside"
    default     = "seaside"
}

variable "aws-region-id" {
    type        = "string"
    description = "The AWS region"
}

variable "environment" {
    type        = "string"
    description = "the name of your environment, e.g. dev-us-east-1 or prod-us-east-2"
    default     = "dev-us-east-1"
}

variable "aws-web-subnet-ids" {
    type        = "list"
    description = "A list of subnets to associate with the AWS ELB instance."
    default     = []
}

variable "aws-web-security-group-ids" {
    type        = "list"
    description = "List of security groups to associate with the AWS ELB instance."
    default     = []
}

variable "aws-instance-type" {
    type        = "string"
    description = "The size of the instance to launchg e.g \"t2.micro\""
    default     = "t2.micro"
}

variable "aws-codedeploy-instance-profile-arn" {
    type = "string"
    description = "The IAM code deploy instance profile to associate with launched instances."
}

variable "aws-ec2-keypair-name" {
    type        = "string"
    description = "The keypair name for ssh access to the instance."
}

variable "associate-public-ip-address" {
    type = "string"
    default = "false"
    description = "Allows you to connect to the instance for debugging when combined with the ssh security group."
}

//
// Resources
//

resource "aws_elb" "aws-elb-web" {
    name = "${var.name}-${var.environment}-aws-elb-web"
    subnets = ["${var.aws-web-subnet-ids}"]
    security_groups = ["${var.aws-web-security-group-ids}"]
    
    cross_zone_load_balancing = true
    idle_timeout = 300
    connection_draining = true
    connection_draining_timeout = 300

    listener {
      instance_port = 80
      instance_protocol = "http"
      lb_port = 80
      lb_protocol = "http"
    }

    health_check {
      healthy_threshold = 2
      unhealthy_threshold = 10
      timeout = 60
      target = "HTTP:80/"
      interval = 300
    }
    
    tags {
      Name = "${var.name}-${var.environment}-aws-elb-web"
    }
}

data "template_file" "userdata" {
    template = "${file("${path.module}/user_data.sh")}"
    vars {
        aws-region-id = "${var.aws-region-id}"
    }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"]
  filter {
    name = "name"
    values = ["ubuntu/images/hvm/ubuntu-trusty-14.04-amd64-server-*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_launch_configuration" "aws-launch-config-web" {
    name_prefix = "${var.name}-${var.environment}-aws-launch-config-web-"
    image_id = "${data.aws_ami.ubuntu.id}"
    instance_type = "${var.aws-instance-type}"
    iam_instance_profile = "${var.aws-codedeploy-instance-profile-arn}"
    key_name = "${var.aws-ec2-keypair-name}"
    security_groups = ["${var.aws-web-security-group-ids}"]
    associate_public_ip_address = "${var.associate-public-ip-address}"
    user_data = "${data.template_file.userdata.rendered}"
    
    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "aws-web-autoscaling-group" {
    name = "${var.name}-${var.environment}-web-autoscaling-group"
    launch_configuration = "${aws_launch_configuration.aws-launch-config-web.name}"
    vpc_zone_identifier = ["${var.aws-web-subnet-ids}"]
    
    min_size = 1
    max_size = 4
    desired_capacity = 4
    
    health_check_grace_period = 300
    health_check_type = "ELB"
    
    load_balancers = ["${aws_elb.aws-elb-web.name}"]
    
    enabled_metrics =[
      "GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"
    ]

    lifecycle {
      create_before_destroy = true
    }

    tag {
        key = "Name"
        value = "${var.name}-${var.environment}-web-instance"
        propagate_at_launch = true
    }
}

//
// Outputs
//

output "aws-auto-scaling-group-web" {
    value = "${aws_autoscaling_group.aws-web-autoscaling-group.name}"
}

output "aws-elb-web-elb-dns-name" {
    value = "${aws_elb.aws-elb-web.dns-name}"
}