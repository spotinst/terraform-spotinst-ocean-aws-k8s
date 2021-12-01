terraform {
  required_version = ">= 0.13.0"

  required_providers {
    spotinst = {
      source  = "spotinst/spotinst"
      version = ">= 1.39.0"
    }
  }
}
