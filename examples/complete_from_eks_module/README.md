<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | ~> 19.0 |
| <a name="module_ocean-aws-k8s"></a> [ocean-aws-k8s](#module\_ocean-aws-k8s) | spotinst/ocean-aws-k8s/spotinst | n/a |
| <a name="module_ocean-controller"></a> [ocean-controller](#module\_ocean-controller) | spotinst/ocean-controller/spotinst | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_instance_profiles.profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_instance_profiles) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ocean_id"></a> [ocean\_id](#output\_ocean\_id) | # Outputs ## |
| <a name="output_worker_instance_profile_arn"></a> [worker\_instance\_profile\_arn](#output\_worker\_instance\_profile\_arn) | n/a |
<!-- END_TF_DOCS -->