//
// Variables
//

variable "name" {
  description = "The name of the security groups serves as a prefix, e.g stack"
}

variable "environment" {
  description = "The environment, used for tagging, e.g prod"
}

variable "aws-vpc-id" {
    description = "The AWS VPC ID."
}

resource "aws_security_group" "elb-security-group" {
  name        = "${var.name}-${var.environment}-external-elb"
  description = "Allows external ELB traffic"
  vpc_id      = "${var.aws-vpc-id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name        = "${var.name}-${var.environment}-external-elb"
    Environment = "${var.environment}"
  }
}


//
// Outputs
//

output "elb-security-group-id" {
  value = "${aws_security_group.elb-security-group.id}"
}
