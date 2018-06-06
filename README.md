# Initializing for Sandbox

```
rm -rf .terraform
export AWS_PROFILE=sandbox
terraform init
terraform workspace select sandbox
```

# Initializing for production

```
rm -rf .terraform
export AWS_PROFILE=scos-alm
terraform init -backend-config=scos-alm-terraform-state
terraform workspace select alm
```