# # Spot Ocean k8s Terraform Module

Spotinst Terraform Module to integrate existing k8s with Ocean

## Prerequisites

Installation of the Ocean controller is required by this resource. You can accomplish this by using the [spotinst/ocean-controller](https://registry.terraform.io/modules/spotinst/ocean-controller/spotinst) module. The kubernetes provider will need to be initilaized before calling the ocean-controller module as follows:

```hcl
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
  worker_instance_profile_arn = "arn:aws:iam::123456789:instance-profile/Spot-EKS-Workshop-Nodegroup"
  security_groups             = ["sg-123456789","sg-123456789"]

  # Overwrite Name Tag and add additional
  tags = {Name = "Ocean-Nodes", CreatedBy = "Terraform"}
}
```

## Providers

| Name | Version |
|------|---------|
| spotinst/spotinst | >= 1.94 |
| hashicorp/aws |         |

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