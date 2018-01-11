# CitrusByte Prototype
> This repository is dedicated to the Terraform scripts used for the Ctrusbyte Prototype infrastructure. 
For more information about Terraform, consult the [Terraform documentation](https://www.terraform.io/docs/).

There were two versions of the application. 
#### v1:
- Is running on ECS.
- Endpoint: `cb.raftech.tk/testme`
- Deployment: managed by a script using awscli to stop task running currrent version and start a version updated. It causes a downtime until the new version is available.Not good.

#### v2:
- Running on Kubernetes cluster on AWS provisioned using Kops.
- Endpoint: `cbv2.raftech.tk/testme`
- Deployment: managed by kubectl. Nicely scheduled deploys.

## Overview
There are two set of templates in this project and a directory containing the k8s definitions:
### v1:
- *infra*
- *app*

Both have separate state files stored at S3. Infra's build outputs data required by the app project. For example, subnets are created at *infra* and used on *app* via terraform_remote_state data, so we need to export that info from *infra* build.

### v2:
- *k8s*

k8s, is a directory that contains:

- cbv2-prototype-pod.yml: just a POD definition for the application. I used deployment to betterhandling of Replicas Controller and replicas Set.
- cbv2-prototype-deployment.yml: Deployment provides declarative updates to PODs and ReplicaSets.
- cbv2-prototype-autoscaling.yml: Using Horizintal Pod Autoscaler the PODs are scaled out/in in the deployment used. It is based on CPUUtilization.
- cbv2-prototype-service.yml: This service is the type LoadBalancer. It manages an ELB to register the EC2 runnning the K8s Nodes.

## Terraform
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
 
### Infra
#### Networking
The AWS architecture makes use of a VPC with public and private subnets. The public subnets have routes to an Internet Gateway, and can receive traffic from the Internet. 
The private subnets can only make outbound requests to the Internet through a NAT Gateway. 
Resources within the public subnets can communicate with resources in the private subnets via their private VPC network interfaces.
Very few resources need to run in the public subnets. Most resources should run in the private subnets and only be exposed to the Internet when necessary, through a resource in the public subnets (usually a load balancer).

#### Updating the Infrastructure
Before any changes can be made to the infrastructure the current state must be loaded from remote storage (S3). To initialize the remote state backend, execute the following command on the tf/infra directory `terraform init -get=true`.

To update the AWS infrastructure, make the appropriate changes in the Terraform scripts, then run `terraform plan` to view the modifications Terraform will make to update the infrastructure and to save the planned changes in *dev.out*. When you are comfortable with the proposed changes, run `terraform apply` to apply the saved plan to the AWS infrastructure.

### App
Here I have defined the strictly needed for the service:
IAM roles and policies, ECS cluster,task definition, Autoscaling Group and the Elastic Load Balancer

It is deokiyed one EC2 per availability zone running ECS containers and ELB doing cross zone balancing.

### Security
VPC subnets are secured with Network ACL rules and instances are secured through the use of Security Groups.
SSH is secured through the use of SSH keys. 
SSL could be implemented by adding a server certificate on the ELB and let it handle the ssl termination.

## Deployment
Pre-requirement: the version to be deployed should be available on DockerHub.

### v1:

In order to deploy a new version of the app that is running on ECS, there are two required steps:
- Update the tf/app/cb-prototype.json and run `terraform apply`
  `"image": "rafabor/prototype-4-cb:v0.0.2"` , specify the tag of the version to be deployed.
- Execute:
  `./deployment.sh $Number_of_desired_tasks` This will start draining the current version tasks, takes ~1min, and then start the desired tasks with the new version.
  Note: don't like the downtime

### v2:

In order to deploy a new version of the app that is running on K8S only one command is needed:
- `kubectl set image deployment/$DEPLOYMENT_NAME $CONTAINER_NAME=$IMAGE`
  $DEPLOYMENT_NAME: cb-prototype-deployment
  $CONTAINER_NAME:  k8s-cbv2
  $IMAGE:           rafabor/prototype-4-cb:v0.0.2

  Kubectl handle the update in a rolling fashion, so no DOWNTIME is caused. Easy to rollback also:
  - `kubectl rollout undo deployment/$DEPLOYMENT_NAME`

