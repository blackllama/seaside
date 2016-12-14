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

variable "aws-acl-tag-name" {
    type        = "string"
    description = "Tag with the name of the default network ACL as in would appear in the AWS Web Console."
    default     = "my-aws-acl"
}

variable "aws-az-mapping" {
    type        = "map"
    description = "A map of availability zones, because count cannot be calculated."
}

variable "aws-igw-tag-name" {
    type        = "string"
    description = "Tag with the name of the internet gateway as in would appear in the AWS Web Console."
    default     = "my-aws-igw"
}

variable "aws-acl-egress-cidr" {
    type        = "string"
    description = "The network range to allow or deny, in CIDR notation."
    default     = "0.0.0.0/0"
}

variable "aws-acl-ingress-cidr" {
    type        = "string"
    description = "The network range to allow or deny, in CIDR notation."
    default     = "0.0.0.0/0"
}

variable "aws-region-id" {
    type        = "string"
    description = "The AWS region in which to build"
}

variable "aws-vpc-tag-name" {
    type        = "string"
    description = "Tag with the name of the VPC as in would appear in the AWS Web Console."
    default     = "my-aws-vpc"
}

variable "aws-subnet-tag-name" {
    type        = "string"
    description = "Tag with the name of the subnet as in would appear in the AWS Web Console."
    default     = "my-aws-subnet"
}

variable "aws-vpc-dns-support" {
    type        = "string"
    description = "A boolean flag to enable/disable DNS support in the VPC."
    default     = "true"
}

variable "aws-vpc-dns-hostnames" {
    type        = "string"
    description = "A boolean flag to enable/disable DNS hostnames in the VPC."
    default     = "false"
}

variable "aws-vpc-tenancy" {
    type        = "string"
    description = "A tenancy option for instances launched into the VPC."
    default     = "default"
}

variable "aws-vpc-cidr-block" {
    type        = "string"
    description = "IP Address range of the VPC in CIDR format, ie. XXX.XXX.XXX.XXX/MM."
    default     = "10.0.0.0/16"
}

//
// Resources
//

resource "aws_vpc" "aws-vpc" {
    cidr_block           = "${var.aws-vpc-cidr-block}"
    instance_tenancy     = "${var.aws-vpc-tenancy}"
    enable_dns_support   = "${var.aws-vpc-dns-support}"
    enable_dns_hostnames = "${var.aws-vpc-dns-hostnames}"
    
    tags {
        Name = "${var.aws-vpc-tag-name}"
    }
    
    lifecycle {
        prevent_destroy = false
    }
}

resource "aws_subnet" "web-subnet" {
    count             = "${length(split(",", lookup(var.aws-az-mapping, var.aws-region-id)))}"
    availability_zone = "${var.aws-region-id}${element(split(",", lookup(var.aws-az-mapping, var.aws-region-id)), count.index)}"
    cidr_block        = "10.0.${count.index}.0/24"
    vpc_id            = "${aws_vpc.aws-vpc.id}"
    
    tags {
        Name  = "${var.aws-subnet-tag-name}-web"
    }
}

resource "aws_subnet" "rds-subnet" {
    count             = "${length(split(",", lookup(var.aws-az-mapping, var.aws-region-id)))}"
    availability_zone = "${var.aws-region-id}${element(split(",", lookup(var.aws-az-mapping, var.aws-region-id)), count.index)}"
    cidr_block        = "10.0.1${count.index}.0/24"
    vpc_id            = "${aws_vpc.aws-vpc.id}"
    
    tags {
        Name  = "${var.aws-subnet-tag-name}-rds"
    }
}

resource "aws_internet_gateway" "aws-igw" {
    vpc_id = "${aws_vpc.aws-vpc.id}"
    tags {
        Name = "${var.aws-igw-tag-name}"
    }
}

resource "aws_route" "aws-igw-route" {
    route_table_id         = "${aws_vpc.aws-vpc.main_route_table_id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = "${aws_internet_gateway.aws-igw.id}"
}

resource "aws_default_network_acl" "aws-acl" {
    default_network_acl_id = "${aws_vpc.aws-vpc.default_network_acl_id}"
    
    ingress {
        protocol   = -1
        rule_no    = 100
        action     = "allow"
        cidr_block = "${var.aws-acl-ingress-cidr}"
        from_port  = 0
        to_port    = 0
    }
    
    egress {
        protocol   = -1
        rule_no    = 100
        action     = "allow"
        cidr_block = "${var.aws-acl-egress-cidr}"
        from_port  = 0
        to_port    = 0
    }
    
    tags {
        Name = "${var.aws-acl-tag-name}"
    }
}

output "aws-vpc-id" {
    value = "${aws_vpc.aws-vpc.id}"
}

output "web-subnets" {
    value = [ "${aws_subnet.web-subnet.*.id}" ]
}

output "rds-subnets" {
    value = [ "${aws_subnet.rds-subnet.*.id}" ]
}

