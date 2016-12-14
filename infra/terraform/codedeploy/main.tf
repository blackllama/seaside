//
// Variables
//

variable "aws-region-id" {}

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

//
// Resources
//

resource "aws_s3_bucket" "codedeploy-bucket" {
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

//
// Output
//

output "codedeploy-bucket-id" {
  value = "${aws_s3_bucket.codedeploy-bucket.id}"
}
