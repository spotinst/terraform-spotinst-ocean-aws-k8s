## Launch Configuration ##
variable "cluster_name" {
  type        = string
  description = "Cluster name"
}
variable "controller_id" {
  type        = string
  default     = null
  description = "Unique identifier for the Ocean controller. If not specified the cluster name will be used."
}
variable "region" {
  type        = string
  description = "The region the cluster is located"
}
variable "max_size" {
  type        = number
  default     = 1000
  description = "The upper limit of worker nodes the Ocean cluster can scale up to"
}
variable "min_size" {
  type        = number
  default     = 1
  description = "The lower limit of worker nodes the Ocean cluster can scale down to"
}
variable "desired_capacity" {
  type        = number
  default     = 1
  description = "The number of worker nodes to launch and maintain in the Ocean cluster"
}
variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs"
}
variable "whitelist" {
  type        = list(string)
  default     = null
  description = "List of instance types allowed in the Ocean cluster (`whitelist` and `blacklist` are mutually exclusive)"
}
variable "blacklist" {
  type        = list(string)
  description = "List of instance types not allowed in the Ocean cluster (`whitelist` and `blacklist` are mutually exclusive)"
  default     = null
}
variable "filters" {
  type = object({
    architectures           = list(string)
    categories              = list(string)
    disk_types              = list(string)
    exclude_families        = list(string)
    exclude_metal           = bool
    hypervisor              = list(string)
    include_families        = list(string)
    is_ena_supported        = bool
    max_gpu                 = number
    min_gpu                 = number
    max_memory_gib          = number
    max_network_performance = number
    max_vcpu                = number
    min_enis                = number
    min_memory_gib          = number
    min_network_performance = number
    min_vcpu                = number
    root_device_types       = list(string)
    virtualization_types    = list(string)
  })
  default     = null
  description = "List of filters. The Instance types that match with all filters compose the Ocean's whitelist parameter. Cannot be configured together with whitelist/blacklist."
}
variable "user_data" {
  type    = string
  default = null
}
variable "ami_id" {
  type        = string
  default     = null
  description = "The image ID for the EKS worker nodes. If none is provided, Terraform will search for the latest version of their EKS optimized worker AMI based on platform"
}
variable "security_groups" {
  type        = list(string)
  description = "One or more security group ids."
}
variable "key_name" {
  type        = string
  default     = null
  description = "The key pair to attach the instances."
}
variable "worker_instance_profile_arn" {
  type        = string
  description = "The instance profile iam role."
}
variable "associate_public_ip_address" {
  type        = bool
  default     = false
  description = "(Optional, Default: false) Configure public IP address allocation."
}
variable "associate_ipv6_address" {
  type        = bool
  default     = false
  description = "(Optional, Default: false) Configure IPv6 address allocation."
}
variable "root_volume_size" {
  type        = number
  default     = null
  description = "The size (in Gb) to allocate for the root volume. Minimum 20."
}
variable "monitoring" {
  type        = bool
  default     = false
  description = "Enable detailed monitoring for cluster. Flag will enable Cloud Watch detailed monitoring (one minute increments). Note: there are additional hourly costs for this service based on the region used."
}
variable "ebs_optimized" {
  type        = bool
  default     = false
  description = "launch specification defined on the Ocean object will function only as a template for virtual node groups."
}
variable "use_as_template_only" {
  type        = bool
  default     = false
  description = "launch specification defined on the Ocean object will function only as a template for virtual node groups."
}

## Load Balancers ##
variable "load_balancer" {
  type = list(object({
    arn  = string
    name = string
    type = string
  }))
  default     = null
  description = "load_balancer object"
}
##########################

variable "tags" {
  type        = map(string)
  default     = null
  description = "Additional Tags to be added to resources"
}
## Ocean Strategy ##
variable "fallback_to_ondemand" {
  type        = bool
  default     = true
  description = "Launch On-Demand in the event there are no EC2 spot instances available"
}
variable "utilize_reserved_instances" {
  type        = bool
  default     = true
  description = "If there are any vacant Reserved Instances, launch On-Demand to consume them"
}
variable "draining_timeout" {
  type        = number
  default     = 120
  description = "Draining timeout before terminating a node"
}
variable "grace_period" {
  type        = number
  default     = 300
  description = "The amount of time, in seconds, after the instance has launched to start checking its health."
}
variable "spot_percentage" {
  type        = number
  default     = null
  description = "The % of the cluster should be running on Spot vs OD. 100 means 100% of the cluster will be ran on Spot instances"
}
variable "utilize_commitments" {
  type        = bool
  default     = false
  description = "If savings plans commitment has available capacity, Ocean will utilize them alongside RIs (if exist) to maximize cost efficiency."
}
variable "spread_nodes_by" {
  type        = string
  default     = "count"
  description = "(Optional, Default: count) Ocean will spread the nodes across markets by this value. Possible values: vcpu or count."
}
variable "availability_vs_cost" {
  type        = string
  default     = "balanced"
  description = "(Optional, Default: balanced) You can control the approach that Ocean takes while launching nodes by configuring this value. Possible values: costOriented,balanced,cheapest."
}
##########################

## instance_metadata_options ##
variable "http_tokens" {
  type        = string
  default     = "optional"
  description = "Determines if a signed token is required or not. Valid values: optional or required."
}
variable "http_put_response_hop_limit" {
  type        = number
  default     = 1
  description = "An integer from 1 through 64. The desired HTTP PUT response hop limit for instance metadata requests. The larger the number, the further the instance metadata requests can travel."
}
##########################

## Auto Scaler ##
variable "autoscale_is_enabled" {
  type        = bool
  default     = true
  description = "Enable the Ocean Kubernetes Auto Scaler."
}
variable "autoscale_is_auto_config" {
  type        = bool
  default     = true
  description = "Automatically configure and optimize headroom resources."
}
variable "autoscale_cooldown" {
  type        = number
  default     = null
  description = "Cooldown period between scaling actions."
}
variable "auto_headroom_percentage" {
  type        = number
  default     = 5
  description = "Set the auto headroom percentage (a number in the range [0, 200]) which controls the percentage of headroom from the cluster."
}
variable "enable_automatic_and_manual_headroom" {
  type        = bool
  default     = null
  description = "Default: false. Enables automatic and manual headroom to work in parallel. When set to false, automatic headroom overrides all other headroom definitions manually configured, whether they are at cluster or VNG level."
}
variable "extended_resource_definitions" {
  type        = list(string)
  default     = null
  description = "List of Ocean extended resource definitions to use in this cluster."
}
## autoscale_headroom ##
variable "cpu_per_unit" {
  type        = number
  default     = null
  description = "Optionally configure the number of CPUs to allocate the headroom. CPUs are denoted in millicores, where 1000 millicores = 1 vCPU."
}
variable "gpu_per_unit" {
  type        = number
  default     = null
  description = "Optionally configure the number of GPUs to allocate the headroom."
}
variable "memory_per_unit" {
  type        = number
  default     = null
  description = "Optionally configure the amount of memory (MB) to allocate the headroom."
}
variable "num_of_unit" {
  type        = number
  default     = null
  description = "The number of units to retain as headroom, where each unit has the defined headroom CPU and memory."
}
## autoscale_down ##
variable "max_scale_down_percentage" {
  type        = number
  default     = 10
  description = "Would represent the maximum % to scale-down. Number between 1-100."
}
## resource_limits ##
variable "max_vcpu" {
  type        = number
  default     = 20000
  description = "The maximum cpu in vCPU units that can be allocated to the cluster."
}
variable "max_memory_gib" {
  type        = number
  default     = 100000
  description = "The maximum memory in GiB units that can be allocated to the cluster."
}
##########################

## Update Policy - update_policy ##
variable "should_roll" {
  type        = string
  default     = false
  description = "Should the cluster be rolled for configuration updates"
}
## roll_config ##
variable "batch_size_percentage" {
  type        = number
  default     = 20
  description = "Sets the percentage of the instances to deploy in each batch."
}
variable "launch_spec_ids" {
  type        = list(string)
  default     = null
  description = "List of virtual node group identifiers to be rolled."
}
variable "respect_pdb" {
  type        = bool
  default     = null
  description = "Default: false. During the roll, if the parameter is set to True we honor PDB during the instance replacement."
}
variable "batch_min_healthy_percentage" {
  type        = number
  default     = null
  description = "Default: 50. Indicates the threshold of minimum healthy instances in single batch. If the amount of healthy instances in single batch is under the threshold, the cluster roll will fail. If exists, the parameter value will be in range of 1-100. In case of null as value, the default value in the backend will be 50%. Value of param should represent the number in percentage (%) of the batch."
}
variable "auto_apply_tags" {
  type        = bool
  default     = null
  description = "Default: false. Will update instance tags on the fly without rolling the cluster."
}
variable "conditioned_roll" {
  type        = bool
  default     = null
  description = "Default: false. Spot will perform a cluster Roll in accordance with a relevant modification of the cluster’s settings. When set to true , only specific changes in the cluster’s configuration will trigger a cluster roll (such as AMI, Key Pair, user data, instance types, load balancers, etc)."
}
variable "conditioned_roll_params" {
  type        = list(string)
  default     = null
  description = "Customized List of conditioned roll params, it is valid only when conditioned_roll set to true"
}
##########################

variable "data_integration_id" {
  type        = string
  default     = null
  description = "The identifier of The S3 data integration to export the logs to."
}

# shutdown_hours #
variable "shutdown_hours" {
  type = object({
    is_enabled   = bool
    time_windows = list(string)
  })
  default     = null
  description = "shutdown_hours object"
}
###################

# task scheduling #
variable "tasks" {
  type = list(object({
    is_enabled      = bool
    cron_expression = string
    task_type       = string
  }))
  default     = null
  description = "task object"
}
## amiAutoUpdate object ##
variable "ami_auto_update" {
  type = object({
    apply_roll    = optional(bool,false)
    minor_version = optional(bool,false)
    patch         = optional(bool,false)
  })
  default     = null
  description = "amiAutoUpdate cluster roll object"
}
## amiAutoUpdate cluster roll ##
variable "ami_auto_update_cluster_roll" {
  type = object({
    batch_min_healthy_percentage = optional(number,null)
    batch_size_percentage = optional(number,null)
    comment = optional(string,null)
    respect_pdb = optional(bool,null)
  })
  default     = null
  description = "amiAutoUpdate cluster roll object"
}

## parameter cluster roll ##
variable "parameters_cluster_roll" {
  type = object({
    batch_min_healthy_percentage = optional(number,null)
    batch_size_percentage = optional(number,null)
    comment = optional(string,null)
    respect_pdb = optional(bool,null)
  })
  default     = null
  description = "parameters cluster roll object"
}
##################

## Block Device Mappings ##
variable "block_device_mappings" {
  description = "Block Device Mapping Object"
  type        = list(any)
  default     = []
}
variable "dynamic_volume_size" {
  type = object({
    base_size              = number
    resource               = string
    size_per_resource_unit = number
  })
  default     = null
  description = "dynamic_volume_size Object"
}
variable "dynamic_iops" {
  type = object({
    base_size              = number
    resource               = string
    size_per_resource_unit = number
  })
  default     = null
  description = "dynamic_iops Object"
}
##################
