//
// Variables
//

variable "aws-region-id" {
  type = "string"
}

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

variable "aws-codedeploy-deploy-config" {
    type        = "string"
    description = "The name of the group's deployment config. , e.g. CodeDeployDefault.OneAtATime"
    default     = "CodeDeployDefault.OneAtATime"
}

variable "aws-codedeploy-service-role-arn" {
    type = "string"
    description = "The service role arn for the codedeploy role"
}

//
// Resources
//

resource "aws_s3_bucket" "aws-codedeploy-bucket" {
    bucket = "${var.name}-${var.environment}-codedeploy-bucket"
    acl = "private"
    force_destroy = true
    region = "${var.aws-region-id}"

    versioning {
      enabled = true
    }

    tags {
      Name = "${var.name}-${var.environment}-codedeploy-bucket"
      Environment = "${var.environment}"
    }
}

resource "aws_codedeploy_app" "aws-codedeploy-app" {
    name = "${var.name}-${var.environment}-codedeploy-app"
}

//
// Output
//

output "aws-codedeploy-bucket-id" {
  value = "${aws_s3_bucket.aws-codedeploy-bucket.id}"
}
