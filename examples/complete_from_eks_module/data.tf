data "aws_eks_cluster" "cluster" {
  depends_on = [module.eks.cluster_id]
  name       = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  depends_on = [module.eks.cluster_id]
  name       = module.eks.cluster_name
}

data "aws_iam_instance_profiles" "profile" {
  depends_on = [module.eks]
  role_name = module.eks.eks_managed_node_groups["one"].iam_role_name
}