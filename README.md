# # Spot Ocean k8s Terraform Module

Spotinst Terraform Module to integrate existing k8s with Ocean

## Prerequisites

Installation of the Ocean controller is required by this resource. You can accomplish this by using the [spotinst/ocean-controller](https://registry.terraform.io/modules/spotinst/ocean-controller/spotinst) module. The kubernetes provider will need to be initilaized before calling the ocean-controller module as follows:

```hcl
terraform {
  required_providers {
    spotinst = {
      source = "spotinst/spotinst"
    }
  }
}

provider "spotinst" {
  token   = "redacted"
  account = "redacted"
}

module "ocean-aws-k8s" {
  source  = "spotinst/ocean-aws-k8s/spotinst"
  ...
}

# Data Resources for kubernetes provider
data "aws_eks_cluster" "cluster" {
  name    = "cluster name"
}
data "aws_eks_cluster_auth" "cluster" {
  name    = "cluster name"
}
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}
##################

module "ocean-controller" {
  source = "spotinst/ocean-controller/spotinst"

  # Credentials.
  spotinst_token   = "redacted"
  spotinst_account = "redacted"

  # Configuration.
  tolerations = []
  cluster_identifier = "cluster name"
}
```

~> You must configure the same `cluster_identifier` both for the Ocean controller and for the `spotinst_ocean_aws` resource. The `ocean-aws-k8s` module will use the cluster name as the identifier. Ensure this is also used in the controller config

## Usage
```hcl
module "ocean-aws-k8s" {
  source = "spotinst/ocean-aws-k8s/spotinst"

  # Configuration
  cluster_name                = "Sample-EKS"
  region                      = "us-west-2"
  subnet_ids                  = ["subnet-12345678","subnet-12345678"]
  #Fetch the instance profile from existing eks managed node group IAM role
  worker_instance_profile_arn = tolist(data.aws_iam_instance_profiles.profile.arns)[0]
  security_groups             = ["sg-123456789","sg-123456789"]

  # Overwrite Name Tag and add additional
  tags = {Name = "Ocean-Nodes", CreatedBy = "Terraform"}
}

data "aws_iam_instance_profiles" "profile" {
  depends_on = [module.eks]
  role_name = module.eks.eks_managed_node_groups["one"].iam_role_name
}
```

## Modules
* `ocean-aws-k8s` - Creates Ocean Cluster
* `ocean-controller` - Create and installs Spot Ocean controller pod [Doc](https://registry.terraform.io/modules/spotinst/ocean-controller/spotinst/latest)
* `ocean-aws-k8s-vng` - (Optional) Add custom virtual node groups [Doc](https://registry.terraform.io/modules/spotinst/ocean-aws-k8s-vng/spotinst/latest)

## Documentation

If you're new to [Spot](https://spot.io/) and want to get started, please checkout our [Getting Started](https://docs.spot.io/connect-your-cloud-provider/) guide, available on the [Spot Documentation](https://docs.spot.io/) website.

## Getting Help

We use GitHub issues for tracking bugs and feature requests. Please use these community resources for getting help:

- Ask a question on [Stack Overflow](https://stackoverflow.com/) and tag it with [terraform-spotinst](https://stackoverflow.com/questions/tagged/terraform-spotinst/).
- Join our [Spot](https://spot.io/) community on [Slack](http://slack.spot.io/).
- Open an issue.

## Community

- [Slack](http://slack.spot.io/)
- [Twitter](https://twitter.com/spot_hq/)

## Contributing

Please see the [contribution guidelines](CONTRIBUTING.md).
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.70 |
| <a name="requirement_spotinst"></a> [spotinst](#requirement\_spotinst) | >= 1.104 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.70 |
| <a name="provider_spotinst"></a> [spotinst](#provider\_spotinst) | >= 1.104 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [spotinst_ocean_aws.ocean](https://registry.terraform.io/providers/spotinst/spotinst/latest/docs/resources/ocean_aws) | resource |
| [aws_ami.eks_worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_default_tags.default_tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/default_tags) | data source |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | The image ID for the EKS worker nodes. If none is provided, Terraform will search for the latest version of their EKS optimized worker AMI based on platform | `string` | `null` | no |
| <a name="input_associate_ipv6_address"></a> [associate\_ipv6\_address](#input\_associate\_ipv6\_address) | (Optional, Default: false) Configure IPv6 address allocation. | `bool` | `false` | no |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | (Optional, Default: false) Configure public IP address allocation. | `bool` | `false` | no |
| <a name="input_auto_apply_tags"></a> [auto\_apply\_tags](#input\_auto\_apply\_tags) | Default: false. Will update instance tags on the fly without rolling the cluster. | `bool` | `null` | no |
| <a name="input_auto_headroom_percentage"></a> [auto\_headroom\_percentage](#input\_auto\_headroom\_percentage) | Set the auto headroom percentage (a number in the range [0, 200]) which controls the percentage of headroom from the cluster. | `number` | `5` | no |
| <a name="input_autoscale_cooldown"></a> [autoscale\_cooldown](#input\_autoscale\_cooldown) | Cooldown period between scaling actions. | `number` | `null` | no |
| <a name="input_autoscale_is_auto_config"></a> [autoscale\_is\_auto\_config](#input\_autoscale\_is\_auto\_config) | Automatically configure and optimize headroom resources. | `bool` | `true` | no |
| <a name="input_autoscale_is_enabled"></a> [autoscale\_is\_enabled](#input\_autoscale\_is\_enabled) | Enable the Ocean Kubernetes Auto Scaler. | `bool` | `true` | no |
| <a name="input_availability_vs_cost"></a> [availability\_vs\_cost](#input\_availability\_vs\_cost) | (Optional, Default: balanced) You can control the approach that Ocean takes while launching nodes by configuring this value. Possible values: costOriented,balanced,cheapest. | `string` | `"balanced"` | no |
| <a name="input_batch_min_healthy_percentage"></a> [batch\_min\_healthy\_percentage](#input\_batch\_min\_healthy\_percentage) | Default: 50. Indicates the threshold of minimum healthy instances in single batch. If the amount of healthy instances in single batch is under the threshold, the cluster roll will fail. If exists, the parameter value will be in range of 1-100. In case of null as value, the default value in the backend will be 50%. Value of param should represent the number in percentage (%) of the batch. | `number` | `null` | no |
| <a name="input_batch_size_percentage"></a> [batch\_size\_percentage](#input\_batch\_size\_percentage) | Sets the percentage of the instances to deploy in each batch. | `number` | `20` | no |
| <a name="input_blacklist"></a> [blacklist](#input\_blacklist) | List of instance types not allowed in the Ocean cluster (`whitelist` and `blacklist` are mutually exclusive) | `list(string)` | `null` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Cluster name | `string` | n/a | yes |
| <a name="input_conditioned_roll"></a> [conditioned\_roll](#input\_conditioned\_roll) | Default: false. Spot will perform a cluster Roll in accordance with a relevant modification of the cluster’s settings. When set to true , only specific changes in the cluster’s configuration will trigger a cluster roll (such as AMI, Key Pair, user data, instance types, load balancers, etc). | `bool` | `null` | no |
| <a name="input_controller_id"></a> [controller\_id](#input\_controller\_id) | Unique identifier for the Ocean controller. If not specified the cluster name will be used. | `string` | `null` | no |
| <a name="input_cpu_per_unit"></a> [cpu\_per\_unit](#input\_cpu\_per\_unit) | Optionally configure the number of CPUs to allocate the headroom. CPUs are denoted in millicores, where 1000 millicores = 1 vCPU. | `number` | `null` | no |
| <a name="input_data_integration_id"></a> [data\_integration\_id](#input\_data\_integration\_id) | The identifier of The S3 data integration to export the logs to. | `string` | `null` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | The number of worker nodes to launch and maintain in the Ocean cluster | `number` | `1` | no |
| <a name="input_draining_timeout"></a> [draining\_timeout](#input\_draining\_timeout) | Draining timeout before terminating a node | `number` | `120` | no |
| <a name="input_ebs_optimized"></a> [ebs\_optimized](#input\_ebs\_optimized) | launch specification defined on the Ocean object will function only as a template for virtual node groups. | `bool` | `false` | no |
| <a name="input_enable_automatic_and_manual_headroom"></a> [enable\_automatic\_and\_manual\_headroom](#input\_enable\_automatic\_and\_manual\_headroom) | Default: false. Enables automatic and manual headroom to work in parallel. When set to false, automatic headroom overrides all other headroom definitions manually configured, whether they are at cluster or VNG level. | `bool` | `null` | no |
| <a name="input_extended_resource_definitions"></a> [extended\_resource\_definitions](#input\_extended\_resource\_definitions) | List of Ocean extended resource definitions to use in this cluster. | `list(string)` | `null` | no |
| <a name="input_fallback_to_ondemand"></a> [fallback\_to\_ondemand](#input\_fallback\_to\_ondemand) | Launch On-Demand in the event there are no EC2 spot instances available | `bool` | `true` | no |
| <a name="input_filters"></a> [filters](#input\_filters) | List of filters. The Instance types that match with all filters compose the Ocean's whitelist parameter. Cannot be configured together with whitelist/blacklist. | <pre>object({<br>    architectures             = list(string)<br>    categories                = list(string)<br>    disk_types                = list(string)<br>    exclude_families          = list(string)<br>    exclude_metal             = bool<br>    hypervisor                = list(string)<br>    include_families          = list(string)<br>    is_ena_supported          = bool<br>    max_gpu                   = number<br>    min_gpu                   = number<br>    max_memory_gib            = number<br>    max_network_performance   = number<br>    max_vcpu                  = number<br>    min_enis                  = number<br>    min_memory_gib            = number<br>    min_network_performance   = number<br>    min_vcpu                  = number<br>    root_device_types         = list(string)<br>    virtualization_types      = list(string)<br>  })</pre> | `null` | no |
| <a name="input_gpu_per_unit"></a> [gpu\_per\_unit](#input\_gpu\_per\_unit) | Optionally configure the number of GPUs to allocate the headroom. | `number` | `null` | no |
| <a name="input_grace_period"></a> [grace\_period](#input\_grace\_period) | The amount of time, in seconds, after the instance has launched to start checking its health. | `number` | `600` | no |
| <a name="input_http_put_response_hop_limit"></a> [http\_put\_response\_hop\_limit](#input\_http\_put\_response\_hop\_limit) | An integer from 1 through 64. The desired HTTP PUT response hop limit for instance metadata requests. The larger the number, the further the instance metadata requests can travel. | `number` | `1` | no |
| <a name="input_http_tokens"></a> [http\_tokens](#input\_http\_tokens) | Determines if a signed token is required or not. Valid values: optional or required. | `string` | `"optional"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | The key pair to attach the instances. | `string` | `null` | no |
| <a name="input_launch_spec_ids"></a> [launch\_spec\_ids](#input\_launch\_spec\_ids) | List of virtual node group identifiers to be rolled. | `list(string)` | `null` | no |
| <a name="input_load_balancer"></a> [load\_balancer](#input\_load\_balancer) | load\_balancer object | <pre>list(object({<br>    arn               = string<br>    name              = string<br>    type              = string<br>  }))</pre> | `null` | no |
| <a name="input_max_memory_gib"></a> [max\_memory\_gib](#input\_max\_memory\_gib) | The maximum memory in GiB units that can be allocated to the cluster. | `number` | `100000` | no |
| <a name="input_max_scale_down_percentage"></a> [max\_scale\_down\_percentage](#input\_max\_scale\_down\_percentage) | Would represent the maximum % to scale-down. Number between 1-100. | `number` | `10` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | The upper limit of worker nodes the Ocean cluster can scale up to | `number` | `1000` | no |
| <a name="input_max_vcpu"></a> [max\_vcpu](#input\_max\_vcpu) | The maximum cpu in vCPU units that can be allocated to the cluster. | `number` | `20000` | no |
| <a name="input_memory_per_unit"></a> [memory\_per\_unit](#input\_memory\_per\_unit) | Optionally configure the amount of memory (MB) to allocate the headroom. | `number` | `null` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | The lower limit of worker nodes the Ocean cluster can scale down to | `number` | `1` | no |
| <a name="input_monitoring"></a> [monitoring](#input\_monitoring) | Enable detailed monitoring for cluster. Flag will enable Cloud Watch detailed monitoring (one minute increments). Note: there are additional hourly costs for this service based on the region used. | `bool` | `false` | no |
| <a name="input_num_of_unit"></a> [num\_of\_unit](#input\_num\_of\_unit) | The number of units to retain as headroom, where each unit has the defined headroom CPU and memory. | `number` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | The region the cluster is located | `string` | n/a | yes |
| <a name="input_respect_pdb"></a> [respect\_pdb](#input\_respect\_pdb) | Default: false. During the roll, if the parameter is set to True we honor PDB during the instance replacement. | `bool` | `null` | no |
| <a name="input_root_volume_size"></a> [root\_volume\_size](#input\_root\_volume\_size) | The size (in Gb) to allocate for the root volume. Minimum 20. | `number` | `null` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | One or more security group ids. | `list(string)` | n/a | yes |
| <a name="input_should_roll"></a> [should\_roll](#input\_should\_roll) | Should the cluster be rolled for configuration updates | `string` | `false` | no |
| <a name="input_shutdown_hours"></a> [shutdown\_hours](#input\_shutdown\_hours) | shutdown\_hours object | <pre>object({<br>    is_enabled   = bool<br>    time_windows = list(string)<br>  })</pre> | `null` | no |
| <a name="input_spot_percentage"></a> [spot\_percentage](#input\_spot\_percentage) | The % of the cluster should be running on Spot vs OD. 100 means 100% of the cluster will be ran on Spot instances | `number` | `null` | no |
| <a name="input_spread_nodes_by"></a> [spread\_nodes\_by](#input\_spread\_nodes\_by) | (Optional, Default: count) Ocean will spread the nodes across markets by this value. Possible values: vcpu or count. | `string` | `"count"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional Tags to be added to resources | `map(string)` | `null` | no |
| <a name="input_tasks"></a> [tasks](#input\_tasks) | task object | <pre>list(object({<br>    is_enabled        = bool<br>    cron_expression   = string<br>    task_type         = string<br>  }))</pre> | `null` | no |
| <a name="input_use_as_template_only"></a> [use\_as\_template\_only](#input\_use\_as\_template\_only) | launch specification defined on the Ocean object will function only as a template for virtual node groups. | `bool` | `false` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | n/a | `string` | `null` | no |
| <a name="input_utilize_commitments"></a> [utilize\_commitments](#input\_utilize\_commitments) | If savings plans commitment has available capacity, Ocean will utilize them alongside RIs (if exist) to maximize cost efficiency. | `bool` | `false` | no |
| <a name="input_utilize_reserved_instances"></a> [utilize\_reserved\_instances](#input\_utilize\_reserved\_instances) | If there are any vacant Reserved Instances, launch On-Demand to consume them | `bool` | `true` | no |
| <a name="input_whitelist"></a> [whitelist](#input\_whitelist) | List of instance types allowed in the Ocean cluster (`whitelist` and `blacklist` are mutually exclusive) | `list(string)` | `null` | no |
| <a name="input_worker_instance_profile_arn"></a> [worker\_instance\_profile\_arn](#input\_worker\_instance\_profile\_arn) | The instance profile iam role. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ocean_controller_id"></a> [ocean\_controller\_id](#output\_ocean\_controller\_id) | The Ocean controller ID |
| <a name="output_ocean_id"></a> [ocean\_id](#output\_ocean\_id) | The Ocean cluster ID |
<!-- END_TF_DOCS -->