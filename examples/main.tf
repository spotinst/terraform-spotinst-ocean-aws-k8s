provider "spotinst" {
  token   = "redacted"
  account = "redacted"
}

## Create Ocean Cluster in Spot.io ##
module "ocean-aws-k8s" {
  source  = "../"

  # Configuration
  cluster_name                = "EKS-Example"
  region                      = "us-west-2"
  subnet_ids                  = ["subnet-12345678","subnet-12345678"]
  # instance profile arn should have the EKSWorkerNodePolicy attached
  worker_instance_profile_arn = "arn:aws:iam::123456789:instance-profile/Spot-EKS-Workshop-Nodegroup"
  security_groups             = ["sg-123456789","sg-123456789"]

  # Additional Tags
  tags = {CreatedBy = "terraform"}
}


## Outputs ##
output "ocean_id" {
  value = module.ocean-aws-k8s.ocean_id
}
