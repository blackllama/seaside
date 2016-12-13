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

variable "aws-profile-name" {
    type        = "string"
    description = "The profile in the AWS credentials file to use"
    default     = "default"
}

variable "aws-region-id" {
    type        = "string"
    description = "The AWS region used by the current AWS Provider definition"
    default     = "ap-east-1"
}

variable "aws-az-mapping" {
    type        = "map"
    description = "Mapping of AWS availability zones by region."
    default {
        "us-east-1"      = "b,c,d,e"
    }
}

//
// Infrastructure
//

provider "aws" {
    profile = "${var.aws-profile-name}"
    region  = "${var.aws-region-id}"
}

module "vpc-stack" {
    aws-acl-tag-name     = "${var.name}-${var.environment}-acl"
    aws-az-mapping       = "${var.aws-az-mapping}"
    aws-igw-tag-name     = "${var.name}-${var.environment}-igw"
    aws-region-id        = "${var.aws-region-id}"
    aws-subnet-tag-name  = "${var.name}-${var.environment}-subnet"
    aws-vpc-tag-name     = "${var.name}-${var.environment}-vpc"
    environment          = "${var.environment}"
    name                 = "${var.name}"
    source               = "./vpc-stack"
}