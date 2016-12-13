# Seaside

## Setup

Install aws by downloading from here: https://aws.amazon.com/cli/

Create a user in AWS IAM called `seaside-infra` which has temporary administrator access so that we can setup our infrastructure. 

Configure aws cli: `aws configure --profile seaside-infra`.

Install terraform by downloading from here: https://www.terraform.io/downloads.html

`cd infra/terraform`

Validate the terraform template:

`> terraform validate`

