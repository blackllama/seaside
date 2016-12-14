//
// Variables
//

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
    description = "The AWS RDS engine to use: aurora mysql oracle pgsql sqlserver"
    default     = "9.6"
}

variable "aws-rds-instance-class" {
    type        = "string"
    description = "The RDS image to use with the RDS instance."
    default     = "db.t2.micro"
}

variable "aws-rds-instance-name" {
    type        = "string"
    description = "The name of the AWS RDS instance as it will appear in the AWS Web Console."
    default     = "my-aws-rds-instance-name"
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

variable "aws-rds-subnets" {
    type        = "list"
    description = "A list of subnets to associate with this instance."
    default     = []
}

variable "aws-rds-vpc-id" {
    type        = "string"
    description = "The AWS VPC ID to associate with this instance's security group."
    default     = ""
}

//
// Resources
//

resource "aws_security_group" "rds-sg" {
    name        = "${var.aws-rds-instance-name}-sg"
    vpc_id      = "${var.aws-rds-vpc-id}"

    ingress {
        from_port       = 5432
        to_port         = 5432
        protocol        = "tcp"
        security_groups = ["${var.aws-rds-sg-ids}"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
        Name        = "${var.aws-rds-instance-name}-sg"
    }
}

resource "aws_db_subnet_group" "rds-subnets" {
    name                   = "${var.aws-rds-instance-name}-subnets"
    subnet_ids             = ["${var.aws-rds-subnets}"]
    
    tags {
        Name = "${var.aws-rds-instance-name}-subnets"
    }
}

resource "aws_db_instance" "rds-instance" {
    allocated_storage      = "${var.aws-rds-storage-size}"
    engine                 = "${var.aws-rds-engine}"
    engine_version         = "${var.aws-rds-engine-version}"
    identifier             = "${var.aws-rds-instance-name}"
    instance_class         = "${var.aws-rds-instance-class}"
    storage_type           = "${var.aws-rds-storage-type}"
    name                   = "${var.aws-rds-db-name}"
    password               = "${var.aws-rds-db-password}"
    username               = "${var.aws-rds-db-username}"
    vpc_security_group_ids = ["${aws_security_group.rds-sg.id}"]
    db_subnet_group_name   = "${aws_db_subnet_group.rds-subnets.name}"
    
    tags {
        Name = "${var.aws-rds-instance-name}"
    }
}

//
// Outputs
//

output "aws-rds-id" {
    value = "${aws_db_instance.rds-instance.id}"
}

output "aws-rds-address" {
    value = "${aws_db_instance.rds-instance.address}"
}
