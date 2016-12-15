# Seaside

## Tools Setup

Install aws by downloading from here: https://aws.amazon.com/cli/

Create a user in AWS IAM called `seaside-infra` which has temporary administrator access so that we can setup our infrastructure. 

Configure aws cli: 

````sh
$ aws configure --profile seaside-infra
````

Install terraform by downloading from here: https://www.terraform.io/downloads.html

Add the terraform executable into your PATH environment variable. 

Rename `terraform` to `tf` to save typing.

In the AWS Console in EC2 create a key pair called `seaside-keypair` so that you can ssh to the bastion EC2 instance.

## AWS Infrastructure Setup

````sh
$ cd infra/terraform
````

Edit the `terraform.tfvars` file for your environment. I've included a sample `dev` environment config.

````tf
name                    = "seaside"
environment             = "dev-east-1"

aws-profile-name        = "seaside-infra"
aws-region-id           = "us-east-1"

aws-rds-db-name         = "seaside"
aws-rds-db-username     = "seaside"
aws-rds-db-password     = "aj8^54sd9$92Kla"
aws-rds-engine          = "postgres"
aws-rds-engine-version  = "9.6"

````

Load the terraform modules:

````sh
$ tf get
````

Validate the terraform template:

````sh
$ tf validate
````

Plan the terraform template:

````sh
$ tf plan
````

Apply the terraform template:

````sh
$ tf apply
````

To destroy the stack:

````sh
$ tf destroy
````

## Deployment

````sh
cd infra/deploy
````

Switch into powershell:

````sh
$ powershell
````

Package web for codedeploy:

````sh
$ ./package.ps1
````

Edit the `./deploy.ps1` file for your environment. I've included a sample `dev` environment.

````ps
$name                           = "seaside"
$environment                    = "dev-east-1"
$aws_region_id                  = "us-east-1"
$aws_profile_name               = "seaside-infra"

$aws_codedeploy_app             = "$name-$environment-codedeploy-app"
$aws_codedeploy_bucket          = "$name-$environment-codedeploy-bucket"
$aws_codedeploy_group_web       = "$name-$environment-aws-codedeploy-group-web"
$aws_codedeploy_deploy_config   = "CodeDeployDefault.OneAtATime"
````

Deploy web via codedeploy:

````sh
$ ./deploy.ps1
````

Once codedeploy has rolled out the deploy, grab the elb dns url and ping the web site!