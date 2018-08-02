# Application Management Lifecycle Network

This Terraform project creates a Continuous Integration/Delivery environment,
including VPC, network, Jenkins master and workers, and a VPN to grant developers access to the environment

## Creating

*** This project relies on [a state bucket](../bootstrap/README.md) and [alm-durable](../alm-durable/README.md) pre-existing. ***

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
