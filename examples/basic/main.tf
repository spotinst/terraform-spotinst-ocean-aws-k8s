## Create Ocean Cluster in Spot.io ##
module "ocean-aws-k8s" {
  source  = "spotinst/ocean-aws-k8s/spotinst"

  # Configuration
  cluster_name                   = "EKS Cluster Name"
  controller_id                  = "EKS-controller-id"
  region                         = "us-west-2"
  subnet_ids                     = ["subnet-12345678","subnet-12345678"]
  min_size                       = 0
  worker_instance_profile_arn    = "arn:aws:iam::123456789:instance-profile/name"
  security_groups                = ["sg-123456789","sg-123456789"]
  ami_id                         = "ami-12345678"
  shutdown_hours                 = {
  is_enabled                     = false
  time_windows                   = ["Sat:08:00-Sun:08:00"]
  }
  tasks                          = [
    {
      is_enabled                   = false
      cron_expression              = "0 9 * * *"
      task_type                    = "amiAutoUpdate"
       ami_auto_update                = [{
          apply_roll                   = false
          minor_version = false
          patch         = true
          ami_auto_update_cluster_roll        = [{
             batch_min_healthy_percentage = 50
             batch_size_percentage        = 20
             comment                      = "Comments for AmiAutUpdate Cluster Roll"
             respect_pdb                  = true
          }]
       }]
    },
   {
       is_enabled                   = false
       cron_expression              = "0 5 * * *"
       task_type                    = "clusterRoll"
       parameters_cluster_roll         = [{
          batch_min_healthy_percentage = 50
          batch_size_percentage        = 20
          comment                      = "Comments for Parameters Cluster Roll"
          respect_pdb                  = false
       }]
    }
  ]

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
  block_device_mappings       = [{
    device_name               = "/dev/xvda"
    encrypted                 = true
    volume_type               = "gp3"
  }
  ]
  dynamic_volume_size         = {
    base_size                 = 60
    resource                  = "CPU"
    size_per_resource_unit    = 30
  }
}
