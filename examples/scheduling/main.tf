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

  shutdown_hours = {
    is_enabled   = false
    time_windows = [  "Tue:01:00-Tue:07:00",
      "Wed:01:00-Wed:07:00",
      "Thu:01:00-Thu:07:00",
      "Fri:01:00-Fri:07:00",
      "Sat:01:00-Sat:07:00",
      "Sun:01:00-Mon:07:00"]
  }
  tasks = [
      {
        is_enabled = false
        cron_expression = "0 9 * * *"
        task_type = "amiAutoUpdate"
         ami_auto_update = [{
            apply_roll = false
            minor_version = false
            patch = true
            ami_auto_update_cluster_roll = [{
               batch_min_healthy_percentage = 50
               batch_size_percentage = 20
               comment = "Comments for AmiAutUpdate Cluster Roll"
               respect_pdb = true
            }]
         }]
      },
     {
         is_enabled = false
         cron_expression = "0 5 * * *"
         task_type = "clusterRoll"
         parameters_cluster_roll = [{
            batch_min_healthy_percentage = 50
            batch_size_percentage = 20
            comment = "Comments for Parameters Cluster Roll"
            respect_pdb = false
         }]
      }
    ]
}