terraform {
  required_version = ">= 1.6.3"

  required_providers {
    spotinst = {
      source  = "spotinst/spotinst"
      version = ">=1.165.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.70"
    }
  }
}
