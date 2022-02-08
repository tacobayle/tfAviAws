# tfAviAws

## Goals
Spin up a full AWS/Avi environment (through Terraform).

## Prerequisites:
- Terraform installed in the orchestrator VM
- AWS credential/details are configured as environment variable:
```
AWS_DEFAULT_REGION=eu-west-1
AWS_SECRET_ACCESS_KEY=****************************
AWS_ACCESS_KEY_ID=****************************
TF_VAR_accessKeyAws=****************************
TF_VAR_secretKeyAws=****************************
TF_VAR_regionAws=eu-west-1
```
- SSH Key (public and private) paths defined in var.ssh_key.public and var.ssh_key.private

## versions:

### terraform
```
Terraform v1.1.4
on linux_amd64
+ provider registry.terraform.io/hashicorp/aws v3.74.1
+ provider registry.terraform.io/hashicorp/null v3.1.0
+ provider registry.terraform.io/hashicorp/template v2.2.0
```

### Avi version
```
Avi 21.1.3
```

### AWS Region:
- eu-west-1 (Ireland)

## Input/Parameters:
All the variables are stored in variables.tf and aws.json

## Use the terraform plan to:
- Create the IAM object for Avi (Policy, Role) and for the jump server
- Create the AWS Network infrastructure (VPC, Internet gateway, Subnet, Route Table, Security Groups) - there are two routing tables (one which allows NAT through the NAT gateway - the other does not)
- Spin up a jump server with ansible installed - userdata to install package - mgt subnet - elastic IP
- Spin up an Avi Controller - mgt subnet - elastic IP
- Spin up backend servers (one per AZ) - backend subnet - userdata to run basic http service
- Spin up auto scaling group (one with 3 servers - one per AZ) - backend subnet - userdata to run basic http service
- Call ansible to do the configuration (avi) based on dynamic inventory

## Run terraform:
```
cd ~ ; git clone https://github.com/tacobayle/TfAviAws ; cd TfAviAws ; terraform init ; terraform apply -auto-approve -var-file=aws.json
# the terraform will output the command to destroy the environment.
```
