## Outputs ##
output "ocean_id" {
  value = module.ocean-aws-k8s.ocean_id
}
output "ocean_controller_id" {
  value = module.ocean-aws-k8s.ocean_controller_id
}
output "worker_instance_profile_arn" {
  value = tolist(data.aws_iam_instance_profiles.profile.arns)[0]
}