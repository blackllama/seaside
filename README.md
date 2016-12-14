# Seaside

## Tools Setup

Install aws by downloading from here: https://aws.amazon.com/cli/

Create a user in AWS IAM called `seaside-infra` which has temporary administrator access so that we can setup our infrastructure. 

Configure aws cli: 

`$ aws configure --profile seaside-infra`

Install terraform by downloading from here: https://www.terraform.io/downloads.html

Add the terraform executable into your PATH environment variable. 

Rename `terraform` to `tf` to save typing.

In the AWS Console in EC2 create a key pair called `seaside-keypair` so that you can ssh to the bastion EC2 instance.

## AWS Infrastructure Setup

`$ cd infra/terraform`

Validate the terraform template:

`$ tf validate`

Plan the terraform template:

`$ tf plan`

Apply the terraform template:

`$ tf apply`

Destroy the terraform template:

`$ tf destroy`