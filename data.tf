data "aws_eks_cluster" "cluster" {
  name    = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name    = var.cluster_name
}

data "aws_ami" "eks_worker" {
  filter {
    name   = "name"
    values = [local.worker_ami_name_filter]
  }
  most_recent = true
  owners = ["amazon"]
}

data "aws_default_tags" "default_tags" {}
