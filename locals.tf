locals {
  worker_ami_name_filter = "amazon-eks-node-${data.aws_eks_cluster.cluster.version}-v*"
}