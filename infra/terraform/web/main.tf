//
// Variables
//

variable "name" {
    type        = "string"
    description = "the name of your stack, e.g. seaside"
    default     = "seaside"
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

//
// Resources
//

resource "aws_elb" "aws-elb-web" {
  name = "${var.name}-${var.environment}-aws-elb-web"
  
  subnets = ["${var.aws-web-subnet-ids}"]
  security_groups = ["${var.aws-web-security-group-ids}"]

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

  cross_zone_load_balancing = true
  idle_timeout = 300
  connection_draining = true
  connection_draining_timeout = 300

  tags {
    Name = "${var.name}-${var.environment}-aws-elb-web"
  }
}

//
// Outputs
//

