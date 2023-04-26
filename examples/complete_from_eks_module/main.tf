module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnet_ids

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }

  eks_managed_node_groups = {
    one = {
      name         = var.eks_nodeGroup
      desired_size = 1
      min_size     = 1
      max_size     = 10

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
    }
  }

  # aws-auth configmap
  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = var.aws_auth_roles_rolearn
      username = var.aws_auth_roles_username
      groups   = var.aws_auth_roles_groups
    },
  ]

  aws_auth_users = [
    {
      userarn  = var.aws_auth_users_userarn
      username = var.aws_auth_users_username
      groups   = var.aws_auth_users_groups
    },
  ]
  tags = var.eks_tags
}

module "ocean-aws-k8s" {
  source = "spotinst/ocean-aws-k8s/spotinst"

  depends_on = [module.eks]

  # Configuration
  cluster_name                = var.cluster_name
  region                      = var.region
  subnet_ids                  = var.subnet_ids
  worker_instance_profile_arn = tolist(data.aws_iam_instance_profiles.profile.arns)[0]
  security_groups             = [module.eks.node_security_group_id]

  # Overwrite Name Tag and add additional
  tags = var.ocean_tags

}

module "ocean-controller" {
  source = "spotinst/ocean-controller/spotinst"

  depends_on = [module.ocean-aws-k8s]

  # Credentials.
  spotinst_token   = var.spotinst_token
  spotinst_account = var.spotinst_account

  # Configuration.
  tolerations = []
  cluster_identifier = var.cluster_name
}
