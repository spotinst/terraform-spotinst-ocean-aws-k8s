provider "spotinst" {
  token   = var.spotinst_token
  account = var.spotinst_account
}

module "[NAME]" {
  source = "../.."
}
