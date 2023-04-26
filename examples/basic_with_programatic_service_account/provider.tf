provider "spotinst" {
  account = var.spotinst_account
  token   = var.spotinst_token
}

provider "aws" {
  region  = var.region
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

#provider for programmatic user
provider "restapi" {
  uri                  = "https://api.spotinst.io"
  write_returns_object = true

  headers = {
    "Authorization" : "Bearer ${var.spotinst_token}"
    "Content-Type" = "application/json"
  }
}