# Application Management Lifecycle Network

This Terraform project creates a Continuous Integration/Delivery environment,
including VPC, network, Jenkins master and workers, and a VPN to grant developers access to the environment

## Creating

*** This project relies on [a state bucket](https://github.com/SmartColumbusOS/scos-bootstrap) and [alm-durable](https://github.com/SmartColumbusOS/scos-alm-durable) pre-existing. ***

### Sandbox

```bash
terraform init --backend-config=../backends/sandbox-alm.conf
terraform apply -var-file=variables/sandbox.tfvars
```

### Production ALM

We didn't feel it was wise to allow the CI environment to modify itself,
so updates to the ALM must be manually applied.

```bash
terraform init --backend-config=../backends/alm.conf
terraform apply -var-file=variables/alm.tfvars
```

### Recreating the Jenkins Task

The Jenkins docker container uses a non-terminating task, this task will not automatically be updated to use the new image.
This can be solved by forcing a deployment

```bash
aws ecs update-service --cluster delivery-pipeline-alm-alm_jenkins_cluster --service jenkins_master --region us-east-2 --force-new-deployment
```

To verify, check the tasks tab for the ECS cluster
https://us-east-2.console.aws.amazon.com/ecs/home?region=us-east-2#/clusters/delivery-pipeline-alm-alm_jenkins_cluster/tasks
