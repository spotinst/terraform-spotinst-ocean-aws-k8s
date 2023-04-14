## Outputs ##
output "ocean_id" {
  value = module.ocean-aws-k8s.ocean_id
}

output "ocean_controller_id" {
  value = module.ocean-aws-k8s.ocean_controller_id
}

output "programmatic_user_token" {
  value       = jsondecode(restapi_object.programmatic_user[0].create_response).response.items.0.token
  description = "Programmatic user token for use with the Spotinst controller pod"
  sensitive   = true
}