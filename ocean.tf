## Create Ocean Cluster in Spot.io
resource "spotinst_ocean_aws" "ocean" {
  name             = var.cluster_name
  controller_id    = var.controller_id == null ? var.cluster_name : var.controller_id
  region           = var.region
  max_size         = var.max_size
  min_size         = var.min_size
  desired_capacity = var.desired_capacity
  subnet_ids       = var.subnet_ids
  whitelist        = var.whitelist
  blacklist        = var.blacklist
  dynamic "filters" {
    for_each = var.filters != null ? [var.filters] : []
    content {
      architectures           = filters.value.architectures
      categories              = filters.value.categories
      disk_types              = filters.value.disk_types
      exclude_families        = filters.value.exclude_families
      exclude_metal           = filters.value.exclude_metal
      hypervisor              = filters.value.hypervisor
      include_families        = filters.value.include_families
      is_ena_supported        = filters.value.is_ena_supported
      max_gpu                 = filters.value.max_gpu
      min_gpu                 = filters.value.min_gpu
      max_memory_gib          = filters.value.max_memory_gib
      max_network_performance = filters.value.max_network_performance
      max_vcpu                = filters.value.max_vcpu
      min_enis                = filters.value.min_enis
      min_memory_gib          = filters.value.min_memory_gib
      min_network_performance = filters.value.min_network_performance
      min_vcpu                = filters.value.min_vcpu
      root_device_types       = filters.value.root_device_types
      virtualization_types    = filters.value.virtualization_types
    }
  }

  user_data = var.user_data != null ? var.user_data : <<-EOF
                                          #!/bin/bash
                                          set -o xtrace
                                          /etc/eks/bootstrap.sh ${var.cluster_name}
                                      EOF

  image_id                                           = var.ami_id != null ? var.ami_id : data.aws_ami.eks_worker.id
  security_groups                                    = var.security_groups
  key_name                                           = var.key_name
  iam_instance_profile                               = var.worker_instance_profile_arn
  associate_public_ip_address                        = var.associate_public_ip_address
  associate_ipv6_address                             = var.associate_ipv6_address
  primary_ipv6                                       = var.primary_ipv6
  root_volume_size                                   = var.root_volume_size
  monitoring                                         = var.monitoring
  ebs_optimized                                      = var.ebs_optimized
  use_as_template_only                               = var.use_as_template_only
  health_check_unhealthy_duration_before_replacement = var.health_check_unhealthy_duration_before_replacement
  reserved_enis                                      = var.reserved_enis

  dynamic "load_balancers" {
    for_each = var.load_balancer != null ? var.load_balancer : []
    content {
      arn  = load_balancers.value.arn
      name = load_balancers.value.name
      type = load_balancers.value.type
    }
  }

  ## Required Tag ##
  tags {
    key   = "kubernetes.io/cluster/${var.cluster_name}"
    value = "owned"
  }
  # Default Provider Tags
  dynamic "tags" {
    for_each = data.aws_default_tags.default_tags.tags
    content {
      key   = tags.key
      value = tags.value
    }
  }
  # Additional Tags
  dynamic "tags" {
    for_each = var.tags == null ? { Name = "${var.cluster_name}-ocean-cluster-node" } : var.tags
    content {
      key   = tags.key
      value = tags.value
    }
  }
  # Strategy
  fallback_to_ondemand       = var.fallback_to_ondemand
  utilize_reserved_instances = var.utilize_reserved_instances
  draining_timeout           = var.draining_timeout
  grace_period               = var.grace_period
  spot_percentage            = var.spot_percentage
  utilize_commitments        = var.utilize_commitments
  spread_nodes_by            = var.spread_nodes_by

  cluster_orientation {
    availability_vs_cost = var.availability_vs_cost
  }

  instance_metadata_options {
    http_tokens                 = var.http_tokens
    http_put_response_hop_limit = var.http_put_response_hop_limit
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
    autoscale_is_enabled                 = var.autoscale_is_enabled
    autoscale_is_auto_config             = var.autoscale_is_auto_config
    autoscale_cooldown                   = var.autoscale_cooldown
    auto_headroom_percentage             = var.auto_headroom_percentage
    enable_automatic_and_manual_headroom = var.enable_automatic_and_manual_headroom
    autoscale_headroom {
      cpu_per_unit    = var.cpu_per_unit
      gpu_per_unit    = var.gpu_per_unit
      memory_per_unit = var.memory_per_unit
      num_of_units    = var.num_of_unit
    }
    autoscale_down {
      max_scale_down_percentage        = var.max_scale_down_percentage
      is_aggressive_scale_down_enabled = var.is_aggressive_scale_down_enabled
    }
    resource_limits {
      max_vcpu       = var.max_vcpu
      max_memory_gib = var.max_memory_gib
    }
  }

  # Policy when config is updated
  update_policy {
    should_roll             = var.should_roll
    conditioned_roll        = var.conditioned_roll
    auto_apply_tags         = var.auto_apply_tags
    conditioned_roll_params = var.conditioned_roll_params
    roll_config {
      batch_size_percentage        = var.batch_size_percentage
      launch_spec_ids              = var.launch_spec_ids
      batch_min_healthy_percentage = var.batch_min_healthy_percentage
      respect_pdb                  = var.respect_pdb
    }
  }

  # Scheduled Task Ami Auto Update, Cluster Roll and shut down hours##
  dynamic "scheduled_task" {
    for_each = var.shutdown_hours != null || var.tasks != null ? [1] : []
    content {
      dynamic "shutdown_hours" {
        for_each = var.shutdown_hours != null ? [var.shutdown_hours] : []
        content {
          is_enabled   = shutdown_hours.value.is_enabled
          time_windows = shutdown_hours.value.time_windows
        }
      }
      dynamic "tasks" {
        for_each = var.tasks != null ? var.tasks : []
        content {
          cron_expression = tasks.value.cron_expression
          is_enabled      = tasks.value.is_enabled
          task_type       = tasks.value.task_type
          parameters {
            dynamic "ami_auto_update" {
              for_each = tasks.value.ami_auto_update
              content {
                apply_roll    = ami_auto_update.value.apply_roll
                minor_version = ami_auto_update.value.minor_version
                patch         = ami_auto_update.value.patch
                dynamic "ami_auto_update_cluster_roll" {
                  for_each = ami_auto_update.value.ami_auto_update_cluster_roll
                  content {
                    batch_min_healthy_percentage = ami_auto_update_cluster_roll.value.batch_min_healthy_percentage
                    batch_size_percentage        = ami_auto_update_cluster_roll.value.batch_size_percentage
                    comment                      = ami_auto_update_cluster_roll.value.comment
                    respect_pdb                  = ami_auto_update_cluster_roll.value.respect_pdb
                  }
                }
              }
            }
            dynamic "parameters_cluster_roll" {
              for_each = tasks.value.parameters_cluster_roll
              content {
                batch_min_healthy_percentage = parameters_cluster_roll.value.batch_min_healthy_percentage
                batch_size_percentage        = parameters_cluster_roll.value.batch_size_percentage
                comment                      = parameters_cluster_roll.value.comment
                respect_pdb                  = parameters_cluster_roll.value.respect_pdb
              }
            }
          }
        }
      }
    }
  }

  ## Block Device Mappings ##
  dynamic "block_device_mappings" {
    for_each = var.block_device_mappings != null ? var.block_device_mappings : []
    content {
      device_name = block_device_mappings.value.device_name
      ebs {
        delete_on_termination = try(block_device_mappings.value.delete_on_termination, null)
        encrypted             = try(block_device_mappings.value.encrypted, null)
        iops                  = try(block_device_mappings.value.iops, null)
        kms_key_id            = try(block_device_mappings.value.kms_key_id, null)
        snapshot_id           = try(block_device_mappings.value.snapshot_id, null)
        volume_type           = try(block_device_mappings.value.volume_type, null)
        volume_size           = try(block_device_mappings.value.volume_size, null)
        throughput            = try(block_device_mappings.value.throughput, null)
        dynamic "dynamic_volume_size" {
          for_each = block_device_mappings.value.dynamic_volume_size
          content {
            base_size              = dynamic_volume_size.value.base_size
            resource               = dynamic_volume_size.value.resource
            size_per_resource_unit = dynamic_volume_size.value.size_per_resource_unit
          }
        }
        dynamic "dynamic_iops" {
          for_each = block_device_mappings.value.dynamic_iops
          content {
            base_size              = dynamic_iops.value.base_size
            resource               = dynamic_iops.value.resource
            size_per_resource_unit = dynamic_iops.value.size_per_resource_unit
          }
        }
      }
    }
  }

  # Prevent Capacity from changing during updates
  lifecycle {
    ignore_changes = [
      desired_capacity
    ]
  }

  resource_tag_specification {
    should_tag_volumes = var.should_tag_volumes
  }

  # attach load balancer
  dynamic "attach_load_balancer" {
    for_each = var.attach_load_balancer != null ? var.attach_load_balancer : []
    content {
      arn  = attach_load_balancer.value.arn
      name = attach_load_balancer.value.name
      type = attach_load_balancer.value.type
    }
  }

  # detach load balancer
  dynamic "detach_load_balancer" {
    for_each = var.detach_load_balancer != null ? var.detach_load_balancer : []
    content {
      arn  = detach_load_balancer.value.arn
      name = detach_load_balancer.value.name
      type = detach_load_balancer.value.type
    }
  }

  instance_store_policy {
    instance_store_policy_type = var.instance_store_policy_type
  }

  dynamic "startup_taints" {
    for_each = var.startup_taints == null ? [] : var.startup_taints
    content {
      key    = startup_taints.value["key"]
      value  = startup_taints.value["value"]
      effect = startup_taints.value["effect"]
    }
  }
}





