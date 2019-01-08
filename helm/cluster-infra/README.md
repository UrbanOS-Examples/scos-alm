# Cluster-Infra

Common Kubernetes cluster services

## ALB Ingress Controller

AWS Application Load Balancer Controller.

Creates ALBs based on Ingresses and their meta-data annotations.

https://github.com/kubernetes-sigs/aws-alb-ingress-controller

## External DNS Controller

Creates DNS records in external DNS systems of major cloud providers, like AWS Route53.

https://github.com/kubernetes-incubator/external-dns

## Calico

Calico is a Kubernetes networking provider that allows you to create network level access controls.

These are some awesome tutorials on the subject.

https://docs.projectcalico.org/v3.3/getting-started/kubernetes/
https://docs.projectcalico.org/v3.3/getting-started/kubernetes/tutorials/simple-policy
https://kubernetes.io/docs/tasks/administer-cluster/declare-network-policy/

If you're looking to work with Calico in Minikube, be sure to start it with the following command to enable the network provider.

```bash
minikube start --memory=8192 --network-plugin=cni --extra-config=kubelet.network-plugin=cni
```
