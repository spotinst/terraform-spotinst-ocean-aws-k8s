locals {
  worker_ami_name_filter = data.aws_eks_cluster.cluster.version <= "1.32" ? "amazon-eks-node-${data.aws_eks_cluster.cluster.version}-v*" : "amazon-eks-node-*-${data.aws_eks_cluster.cluster.version}-v*"
}

