output "ocean_id" {
  value       = spotinst_ocean_aws.ocean.id
  description = "The Ocean cluster ID"
}
output "ocean_controller_id" {
  value       = spotinst_ocean_aws.ocean.controller_id
  description = "The Ocean controller ID"
}
