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

variable "aws-ec2-keypair-name" {
    type        = "string"
    description = "The keypair name for ssh access to the instance. e.g. seaside-keypair",
    default = "seaside-keypair"
}

// RDS

variable "aws-rds-db-name" {
    type        = "string"
    description = "The name of the database to install."
    default     = "mydb"
}

variable "aws-rds-db-password" {
    type        = "string"
    description = "The password for the database."
    default     = "mydbpass"
}

variable "aws-rds-db-username" {
    type        = "string"
    description = "The username for the database."
    default     = "mydbuser"
}

variable "aws-rds-engine" {
    type        = "string"
    description = "The AWS RDS engine to use: aurora mysql oracle pgsql sqlserver"
    default     = "postgres"
}

variable "aws-rds-engine-version" {
    type        = "string"
    description = "The engine version to use."
    default     = "9.6"
}

variable "aws-rds-instance-class" {
    type        = "string"
    description = "The RDS image to use with the RDS instance."
    default     = "db.t2.micro"
}

variable "aws-rds-sg-ids" {
    type        = "list"
    description = "List of security groups to associate with the AWS RDS instance."
    default     = []
}

variable "aws-rds-storage-size" {
    type        = "string"
    description = "The storage size of an RDS instance."
    default     = "10"
}

variable "aws-rds-storage-type" {
    type        = "string"
    description = "The storage type of an RDS instance."
    default     = "gp2"
}

//
// Infrastructure
//

provider "aws" {
    profile = "${var.aws-profile-name}"
    region  = "${var.aws-region-id}"
}

module "vpc-stack" {
    source               = "./vpc-stack"
    aws-acl-tag-name     = "${var.name}-${var.environment}-acl"
    aws-az-mapping       = "${var.aws-az-mapping}"
    aws-igw-tag-name     = "${var.name}-${var.environment}-igw"
    aws-region-id        = "${var.aws-region-id}"
    aws-subnet-tag-name  = "${var.name}-${var.environment}-subnet"
    aws-vpc-tag-name     = "${var.name}-${var.environment}-vpc"
    environment          = "${var.environment}"
    name                 = "${var.name}"
}

module "security-groups" {
    source = "./security-groups"
    name = "${var.name}"
    environment = "${var.environment}"
    aws-vpc-id = "${module.vpc-stack.aws-vpc-id}"
}

# module "rds-instance" {
#     source                 = "./rds-instance"
#     aws-rds-storage-size   = "${var.aws-rds-storage-size}"
#     aws-rds-engine         = "${var.aws-rds-engine}"
#     aws-rds-engine-version = "${var.aws-rds-engine-version}"
#     aws-rds-instance-name  = "${var.name}-${var.environment}-rds"
#     aws-rds-instance-class = "${var.aws-rds-instance-class}"
#     aws-rds-storage-type   = "${var.aws-rds-storage-type}"
#     aws-rds-db-name        = "${var.aws-rds-db-name}"
#     aws-rds-db-password    = "${var.aws-rds-db-password}"
#     aws-rds-db-username    = "${var.aws-rds-db-username}"
#     aws-rds-vpc-id         = "${module.vpc-stack.aws-vpc-id}"
#     aws-rds-sg-ids         = ["${module.security-groups.web-sg-id}", "${module.security-groups.bastion-sg-id}"]
#     aws-rds-subnets        = ["${module.vpc-stack.rds-subnets}"]
# }

# module "bastion" {
#     source                  = "./bastion"
#     aws-ec2-subnet-id       = "${module.vpc-stack.web-subnets[0]}"
#     aws-ec2-keypair-name    = "${var.aws-ec2-keypair-name}"
#     aws-ec2-sg-ids          = ["${module.security-groups.bastion-sg-id}"]
#     environment             = "${var.environment}"
#     name                    = "${var.name}"
# }

module "iam" {
    source                  = "./iam"
    environment             = "${var.environment}"
    name                    = "${var.name}"
    aws-region-id           = "${var.aws-region-id}"
}

module "codedeploy" {
    source = "./codedeploy"
    environment             = "${var.environment}"
    name                    = "${var.name}"
    aws-region-id           = "${var.aws-region-id}"
}