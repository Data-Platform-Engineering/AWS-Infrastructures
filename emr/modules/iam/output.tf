output "aws_iam_instance_profile_arn" {
 value = aws_iam_instance_profile.emr_profile.arn
}
output "iam_emr_service_role_arn" {
  value = aws_iam_role.iam_emr_service_role.arn
}
output "emr_autoscaling_role_arn" {
 value = aws_iam_role.auto_scaling_role.arn
}