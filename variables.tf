## Launch Configuration ##
variable "cluster_name" {
  type        = string
  description = "Cluster name"
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
  default     = [
    "c6g.12xlarge",
    "c6g.16xlarge",
    "c6g.2xlarge",
    "c6g.4xlarge",
    "c6g.8xlarge",
    "c6g.large",
    "c6g.medium",
    "c6g.metal",
    "c6g.xlarge",
    "c6gd.12xlarge",
    "c6gd.16xlarge",
    "c6gd.2xlarge",
    "c6gd.4xlarge",
    "c6gd.8xlarge",
    "c6gd.large",
    "c6gd.medium",
    "c6gd.metal",
    "c6gd.xlarge",
    "c6gn.12xlarge",
    "c6gn.16xlarge",
    "c6gn.2xlarge",
    "c6gn.4xlarge",
    "c6gn.8xlarge",
    "c6gn.large",
    "c6gn.medium",
    "c6gn.xlarge",
    "m6g.12xlarge",
    "m6g.16xlarge",
    "m6g.2xlarge",
    "m6g.4xlarge",
    "m6g.8xlarge",
    "m6g.large",
    "m6g.medium",
    "m6g.metal",
    "m6g.xlarge",
    "m6gd.12xlarge",
    "m6gd.16xlarge",
    "m6gd.2xlarge",
    "m6gd.4xlarge",
    "m6gd.8xlarge",
    "m6gd.large",
    "m6gd.medium",
    "m6gd.metal",
    "m6gd.xlarge",
    "r6g.12xlarge",
    "r6g.16xlarge",
    "r6g.2xlarge",
    "r6g.4xlarge",
    "r6g.8xlarge",
    "r6g.large",
    "r6g.medium",
    "r6g.metal",
    "r6g.xlarge",
    "r6gd.12xlarge",
    "r6gd.16xlarge",
    "r6gd.2xlarge",
    "r6gd.4xlarge",
    "r6gd.8xlarge",
    "r6gd.large",
    "r6gd.medium",
    "r6gd.metal",
    "r6gd.xlarge",
    "t2.medium",
    "t2.xlarge",
    "t2.large",
    "t2.2xlarge",
    "t2.micro",
    "t2.small",
    "t3.small",
    "t3.medium",
    "t3.xlarge",
    "t3.2xlarge",
    "t3.large",
    "t3.micro",
    "t3a.large",
    "t3a.xlarge",
    "t3a.medium",
    "t3a.2xlarge",
    "t3a.small",
    "t3a.micro",
    "t4g.2xlarge",
    "t4g.large",
    "t4g.medium",
    "t4g.micro",
    "t4g.small",
    "t4g.xlarge"]
}
variable "user_data" {
  type        = string
  default     = null
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
  default     = null
  description = "Associate a public IP address to worker nodes"
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
    arn               = string
    name              = string
    type              = string
  }))
  default             = null
  description         = "load_balancer object"
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
  default     = 600
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
  default = null
  description = "shutdown_hours object"
}
###################

# task scheduling #
variable "tasks" {
  type = list(object({
    is_enabled        = bool
    cron_expression   = string
    task_type         = string
  }))
  default = null
  description = "task object"
}
###################