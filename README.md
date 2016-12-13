# Seaside

## Tools

Install aws by downloading from here: https://aws.amazon.com/cli/

Create a user in AWS IAM called `seaside-infra` which has temporary administrator access so that we can setup our infrastructure. 

Configure aws cli: 

`$ aws configure --profile seaside-infra`

Install terraform by downloading from here: https://www.terraform.io/downloads.html

Add the terraform executable into your PATH environment variable. 

Rename `terraform` to `tf` to save typing.

## Setup

`cd infra/terraform`

Validate the terraform template:

`$ terraform validate`

Plan the terraform template:

`$ terraform plan`

Apply the terraform template:

`$ terraform apply`

Destroy the terraform template:

`$ terraform destroy`