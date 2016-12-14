// 
// Variables
//

variable "aws-region-id" {}

variable "name" {
  description = "The name of the stack to use in security groups"
}

variable "environment" {
  description = "The name of the environment for this stack"
}

//
// Resources
//

resource "aws_iam_role" "codedeploy-service-role" {
    name = "${var.name}-${var.environment}-codedeploy-service-role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "codedeploy.us-east-1.amazonaws.com", 
          "codedeploy.us-west-1.amazonaws.com",
          "codedeploy.us-west-2.amazonaws.com",
          "codedeploy.ap-northeast-1.amazonaws.com",
          "codedeploy.ap-northeast-2.amazonaws.com",
          "codedeploy.ap-south-1.amazonaws.com",
          "codedeploy.ap-southeast-1.amazonaws.com",
          "codedeploy.ap-southeast-2.amazonaws.com",
          "codedeploy.eu-central-1.amazonaws.com",
          "codedeploy.eu-west-1.amazonaws.com",
          "codedeploy.sa-east-1.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "codedeploy-service-role-attach" {
    role = "${aws_iam_role.codedeploy-service-role.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

resource "aws_iam_role" "codedeploy-instance-role" {
    name = "${var.name}-${var.environment}-codedeploy-instance-role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codedeploy-instance-role-policy" {
    name = "${var.name}-${var.environment}-codedeploy-instance-role-policy"
    role = "${aws_iam_role.codedeploy-instance-role.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:Get*",
        "s3:List*",
        "autoscaling:*",
        "elasticloadbalancing:*",
        "sqs:*",
        "s3:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "codedeploy-instance-profile" {
    name = "${var.name}-${var.environment}-codedeploy-instance-profile"
    roles = ["${aws_iam_role.codedeploy-instance-role.name}"]
}

//
// Outputs
//

output "aws-codedeploy-service-role-arn" {
  value = "${aws_iam_role.codedeploy-service-role.arn}"
}

output "aws-codedeploy-instance-role-arn" {
  value = "${aws_iam_role.codedeploy-instance-role.arn}"
}

output "aws-codedeploy-instance-profile-arn" {
  value = "${aws_iam_instance_profile.codedeploy-instance-profile.arn}"
}
