## Create Ocean Cluster in Spot.io ##
module "ocean-aws-k8s" {
  source  = "spotinst/ocean-aws-k8s/spotinst"

  # Configuration
  cluster_name                                       = "EKS Cluster Name"
  controller_id                                      = "EKS-controller-id"
  region                                             = "us-west-2"
  subnet_ids                                         = ["subnet-12345678","subnet-12345678"]
  min_size                                           = 0
  worker_instance_profile_arn                        = "arn:aws:iam::123456789:instance-profile/name"
  security_groups                                    = ["sg-123456789","sg-123456789"]
  ami_id                                             = "ami-12345678"
  should_tag_volumes                                 = true
  is_aggressive_scale_down_enabled                   = false
  health_check_unhealthy_duration_before_replacement = 60
  # Additional Tags
  tags = {CreatedBy = "terraform"}
  # Block Device Mappings
  block_device_mappings       = [
    {
    device_name               = "/dev/xvda"
    delete_on_termination     = true
    encrypted                 = false
    kms_key_id                = "alias/aws/ebs"
    snapshot_id               = null
    volume_type               = "gp3"
    volume_size               = null
    throughput                = 125
    dynamic_volume_size         = [{
        base_size                 = 30
        resource                  = "CPU"
        size_per_resource_unit    = 25
    }]
    dynamic_iops                = [{
        base_size                 = 20
        resource                  = "CPU"
        size_per_resource_unit    = 12
    }]
  },
  {
     device_name               = "/dev/xvda"
     encrypted                 = true
     iops                      = 100
     volume_type               = "gp3"
     dynamic_volume_size         = [{
        base_size                 = 50
        resource                  = "CPU"
        size_per_resource_unit    = 20
     }]
  }
  ]
}
