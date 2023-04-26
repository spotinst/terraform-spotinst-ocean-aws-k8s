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

  filters = {
    architectures             = ["x86_64", "arm64"]
    categories                = ["Accelerated_computing", "Compute_optimized", "General_purpose"]
    disk_types                = ["EBS", "NVMe"]
    exclude_families          = null
    exclude_metal             = null
    hypervisor                = null
    include_families          = null
    is_ena_supported          = true
    max_gpu                   = null
    min_gpu                   = null
    max_memory_gib            = null
    max_network_performance   = null
    max_vcpu                  = null
    min_enis                  = null
    min_memory_gib            = null
    min_network_performance   = null
    min_vcpu                  = 2
    root_device_types         = null
    virtualization_types      = null
  }

}