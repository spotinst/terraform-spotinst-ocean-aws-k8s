## Create Ocean Cluster in Spot.io ##
module "ocean-aws-k8s" {
  source  = "spotinst/ocean-aws-k8s/spotinst"

  # Configuration
  cluster_name                = "EKS-Example"
  region                      = "us-west-2"
  subnet_ids                  = ["subnet-12345678","subnet-12345678"]
  # instance profile arn should have the EKSWorkerNodePolicy attached
  worker_instance_profile_arn = "arn:aws:iam::123456789:instance-profile/Spot-EKS-Workshop-Nodegroup"
  security_groups             = ["sg-123456789","sg-123456789"]

  # Additional Tags
  tags = {CreatedBy = "terraform"}

  load_balancer = [
    {
      arn               = "arn:aws:elasticloadbalancing:us-west-2:123456789:targetgroup/ALB-sandbox/af01fd9e94c06762",
      name              = "Example"
      type              = "TARGET_GROUP"
    }
  ]
  # update_policy
  should_roll           = true
  auto_apply_tags       = true
  batch_size_percentage = 20
  respect_pdb           = false
}


## Outputs ##
output "ocean_id" {
  value = module.ocean-aws-k8s.ocean_id
}
