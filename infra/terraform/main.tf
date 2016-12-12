//
// Variables
//

// The AWS profile name to use.
variable "aws-profile-name" {
    type        = "string"
    description = "The profile in the AWS credentials file to use"
    default     = "default"
}

// The AWS region in which to build.
variable "aws-region-id" {
    type        = "string"
    description = "The AWS region used by the current AWS Provider definition"
    default     = "ap-east-1"
}

//
// Infrastructure
//

provider "aws" {
    profile = "${var.aws-profile-name}"
    region  = "${var.aws-region-id}"
}

