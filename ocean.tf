## Create Ocean Cluster in Spot.io

resource "spotinst_ocean_aws" "ocean" {
  name                                = var.cluster_name
  controller_id                       = var.cluster_name
  region                              = var.region
  max_size                            = var.max_size
  min_size                            = var.min_size
  desired_capacity                    = var.desired_capacity
  subnet_ids                          = var.subnet_ids
  whitelist                           = var.whitelist
  blacklist                           = var.blacklist
  user_data                           = var.user_data !=null ? var.user_data : <<-EOF
                                          #!/bin/bash
                                          set -o xtrace
                                          /etc/eks/bootstrap.sh ${var.cluster_name}
                                      EOF

  image_id                            = var.ami_id != null ? var.ami_id : data.aws_ami.eks_worker.id
  security_groups                     = var.security_groups
  key_name                            = var.key_name
  iam_instance_profile                = var.worker_instance_profile_arn
  associate_public_ip_address         = var.associate_public_ip_address
  root_volume_size                    = var.root_volume_size
  monitoring                          = var.monitoring
  ebs_optimized                       = var.ebs_optimized
  use_as_template_only                = var.use_as_template_only

  dynamic "load_balancers" {
    for_each = var.load_balancer != null ? var.load_balancer : []
    content {
      arn   = load_balancers.value.arn
      name  = load_balancers.value.name
      type  = load_balancers.value.type
    }
  }

  ## Required Tag ##
  tags {
    key   = "kubernetes.io/cluster/${var.cluster_name}"
    value = "owned"
  }
  # Default Provider Tags
  dynamic tags {
    for_each = data.aws_default_tags.default_tags.tags
    content {
      key = tags.key
      value = tags.value
    }
  }
  # Additional Tags
  dynamic tags {
    for_each = var.tags == null ? {Name = "${var.cluster_name}-ocean-cluster-node"} : var.tags
    content {
      key = tags.key
      value = tags.value
    }
  }
  # Strategy
  fallback_to_ondemand            = var.fallback_to_ondemand
  utilize_reserved_instances      = var.utilize_reserved_instances
  draining_timeout                = var.draining_timeout
  grace_period                    = var.grace_period
  spot_percentage                 = var.spot_percentage
  utilize_commitments             = var.utilize_commitments

  instance_metadata_options {
    http_tokens                   = var.http_tokens
    http_put_response_hop_limit   = var.http_put_response_hop_limit
  }

  dynamic "logging" {
    for_each = var.data_integration_id != null ? [var.data_integration_id] : []
    content {
      export {
        s3 {
          id = var.data_integration_id
        }
      }
    }
  }

  # Auto Scaler Configurations
  autoscaler {
    autoscale_is_enabled                  = var.autoscale_is_enabled
    autoscale_is_auto_config              = var.autoscale_is_auto_config
    autoscale_cooldown                    = var.autoscale_cooldown
    auto_headroom_percentage              = var.auto_headroom_percentage
    enable_automatic_and_manual_headroom  = var.enable_automatic_and_manual_headroom
    autoscale_headroom {
      cpu_per_unit                        = var.cpu_per_unit
      gpu_per_unit                        = var.gpu_per_unit
      memory_per_unit                     = var.memory_per_unit
      num_of_units                        = var.num_of_unit
    }
    autoscale_down {
      max_scale_down_percentage           = var.max_scale_down_percentage
    }
    resource_limits {
      max_vcpu                            = var.max_vcpu
      max_memory_gib                      = var.max_memory_gib
    }
  }

  # Policy when config is updated
  update_policy {
    should_roll                           = var.should_roll
    conditioned_roll                      = var.conditioned_roll
    auto_apply_tags                       = var.auto_apply_tags
    roll_config {
      batch_size_percentage               = var.batch_size_percentage
      launch_spec_ids                     = var.launch_spec_ids
      batch_min_healthy_percentage        = var.batch_min_healthy_percentage
      respect_pdb                         = var.respect_pdb
    }
  }


  # Scheduled Task ##
  scheduled_task {
    dynamic "shutdown_hours" {
      for_each            = var.shutdown_hours != null ? [var.shutdown_hours] : []
      content {
        is_enabled        = shutdown_hours.value.is_enabled
        time_windows      = shutdown_hours.value.time_windows
      }
    }
    dynamic "tasks" {
      for_each            = var.tasks != null ? var.tasks : []
      content {
        is_enabled        = tasks.value.is_enabled
        cron_expression   = tasks.value.cron_expression
        task_type         = tasks.value.task_type
      }
    }
  }


  # Prevent Capacity from changing during updates
  lifecycle {
    ignore_changes = [
      desired_capacity
    ]
  }
}