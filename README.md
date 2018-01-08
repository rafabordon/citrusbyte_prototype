# CitrusByte Prototype
> This repository is dedicated to the Terraform scripts used for the Ctrusbyte Prototype infrastructure. 
For more information about Terraform, consult the [Terraform documentation](https://www.terraform.io/docs/).

## Overview
There are two set of templates in this project:
- *infra*
- *app*

Both have separate state files stored at S3. Infra's build outputs data required by the app project. For example, subnets are created at *infra* and used on *app* via terraform_remote_state data, so we need to export that info from *infra* build.

### Terraform
Terraform maintains the state of AWS resources in *tfstate* files and compares the resources declared in the Terraform scripts to determine whether changes to the infrastructure should be made. Terraform stores the state files remotely in S3 and can be referenced by other scripts to integrate with and utilize the resources.

In order to run terraform and use the respective AWS account, create under ~/.aws/ the following files (update as needed):

```
~/.aws/config
[profile username]
region = us-east-1
output = json

~/.aws/credentials
[username]
aws_access_key_id = XXXXXXXXXXXXXX
aws_secret_access_key = xxxxxxxxxxxxxxxxxxxxxxxxx
```

Then in order to make terraform use the right authentication data export the following environment variable:
`export AWS_PROFILE=username`
 
#### Infra
##### Networking
The AWS architecture makes use of a VPC with public and private subnets. The public subnets have routes to an Internet Gateway, and can receive traffic from the Internet. 
The private subnets can only make outbound requests to the Internet through a NAT Gateway. 
Resources within the public subnets can communicate with resources in the private subnets via their private VPC network interfaces.
Very few resources need to run in the public subnets. Most resources should run in the private subnets and only be exposed to the Internet when necessary, through a resource in the public subnets (usually a load balancer).

##### Updating the Infrastructure
Before any changes can be made to the infrastructure the current state must be loaded from remote storage (S3). To initialize the remote state backend, execute the following command on the tf/infra directory `terraform init -get=true`.

To update the AWS infrastructure, make the appropriate changes in the Terraform scripts, then run `terraform plan` to view the modifications Terraform will make to update the infrastructure and to save the planned changes in *dev.out*. When you are comfortable with the proposed changes, run `terraform apply` to apply the saved plan to the AWS infrastructure.

#### App
Here I have defined the strictly needed for the service:
IAM roles and policies, ECS cluster,task definition, Autoscaling Group and the Elastic Load Balancer

It is deokiyed one EC2 per availability zone running ECS containers and ELB doing cross zone balancing.

#### Security
VPC subnets are secured with Network ACL rules and instances are secured through the use of Security Groups.
SSH is secured through the use of SSH keys. 
SSL could be implemented by adding a server certificate on the ELB and let it handle the ssl termination.

### TODO
Pipeline for the automated deployment.
