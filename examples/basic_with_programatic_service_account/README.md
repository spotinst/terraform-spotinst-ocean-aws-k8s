<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_restapi"></a> [restapi](#provider\_restapi) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ocean-aws-k8s"></a> [ocean-aws-k8s](#module\_ocean-aws-k8s) | spotinst/ocean-aws-k8s/spotinst | n/a |
| <a name="module_ocean-controller"></a> [ocean-controller](#module\_ocean-controller) | spotinst/ocean-controller/spotinst | n/a |

## Resources

| Name | Type |
|------|------|
| [restapi_object.programmatic_user](https://registry.terraform.io/providers/mastercard/restapi/latest/docs/resources/object) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ocean_controller_id"></a> [ocean\_controller\_id](#output\_ocean\_controller\_id) | n/a |
| <a name="output_ocean_id"></a> [ocean\_id](#output\_ocean\_id) | # Outputs ## |
| <a name="output_programmatic_user_token"></a> [programmatic\_user\_token](#output\_programmatic\_user\_token) | Programmatic user token for use with the Spotinst controller pod |
<!-- END_TF_DOCS -->