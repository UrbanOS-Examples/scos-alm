#!/bin/bash
load_balancer() {
    echo $(kubectl describe service ${1} | grep Ingress | awk '{print $3}')
}

terraform init --backend-config=bucket=scos-alm-terraform-state
terraform workspace select alm

terraform plan -target=aws_ecs_service.cota-proxy \
    -var-file=variables/alm.tfvars \
    -var cota_ui_host=$(load_balancer cota-streaming-ui) \
    -var streaming_consumer_host=$(load_balancer cota-streaming-consumer) \
    -out cota-proxy.plan

terraform apply cota-proxy.plan