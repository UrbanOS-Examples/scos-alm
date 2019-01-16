module "eks" {
  source = "git@github.com:SmartColumbusOS/scos-tf-eks?ref=1.0.0"

  public_subnets                   = "${module.vpc.public_subnets}"
  vpc_id                           = "${module.vpc.vpc_id}"
  role_arn                         = "${var.alm_role_arn}"
  chatter_sg_arn                   = "${aws_security_group.chatter.id}"
  allow_all_sg_arn                 = "${aws_security_group.allow_all.id}"
  cloud_key_name                   = "${aws_key_pair.cloud_key.key_name}"
  tls_cert_arn                     = "${module.tls_certificate.arn}"
  internal_public_hosted_zone_name = "${local.internal_public_hosted_zone_name}"
  region                           = "${var.region}"
}

output "eks_cluster_kubeconfig" {
  description = "Working kubeconfig to talk to the eks cluster."
  value       = "${module.eks.eks_cluster_kubeconfig}"
}

output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = "${module.eks.eks_cluster_name}"
}

output "eks_worker_role_arn" {
  description = "EKS Worker Role ARN"
  value       = "${module.eks.eks_worker_role_arn}"
}

resource "aws_iam_policy" "eks_worker_policy" {
  name        = "eks-worker-policy"
  path        = "/"
  description = ""

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:iam::993761728866:role/CostExplorer"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "eks_worker_policy_attachment" {
  role       = "${module.eks.eks_worker_role_name}"
  policy_arn = "${aws_iam_policy.eks_worker_policy.arn}"
}
