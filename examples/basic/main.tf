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
  # Block Device Mappings
  block_device_mappings       = [{
    device_name               = "/dev/xvda"
    delete_on_termination     = true
    encrypted                 = false
    kms_key_id                = "alias/aws/ebs"
    snapshot_id               = null
    iops                      = 1
    volume_type               = "gp3"
    volume_size               = null
    throughput                = 125 }]
  dynamic_volume_size         = {
    base_size                 = 50
    resource                  = "CPU"
    size_per_resource_unit    = 20 }
  dynamic_iops                = {
    base_size                 = 30
    resource                  = "CPU"
    size_per_resource_unit    = 10 }
  # Images
  images                      = {image_id = "ami-12345"}
}
