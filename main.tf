terraform {
  required_providers {
    spotinst = {
      source = "spotinst/spotinst"
    }
  }
}

# 1) Configure the Spot provider
provider "spotinst" {
  token   = "aaabbbccc"
  account = "act-11111"
}

# 2) Create the Ocean cluster in Spot
module "ocean-aws-k8s" {
  source = "spotinst/ocean-aws-k8s/spotinst"

  cluster_name = "eks-thinh-dev"
  region       = "us-east-2"

  subnet_ids = [
    "subnet-036fefdcbc5e51284",
    "subnet-0a68a21f6b7931624",
    "subnet-0080f4c676c83e623",
    "subnet-05b1945a54b788854",
    "subnet-0307e7fe1b165d815",
    "subnet-063a24e3532545f73",
  ]

  worker_instance_profile_arn = "arn:aws:iam::123456789012:instance-profile/your-instance-profile"
  security_groups             = ["sg-0730525eaaddcf6d4"]

  # capacity
  min_size         = 0
  desired_capacity = 0

  # --- Ocean strategy fields (matching ApiOceanStrategy conceptually) ---
  utilize_reserved_instances = true
  utilize_commitments        = false
  fallback_to_ondemand       = true
  spot_percentage            = null   # or 100 / 80 / etc (null lets Spot decide / defaults)
  draining_timeout           = 120
  grace_period               = 300
  spread_nodes_by            = "count" # or "vcpu"
  max_replacements_percentage = 25

  # Strategy > clusterOrientation
  availability_vs_cost = "balanced"   # or "costOriented" / "cheapest"
}