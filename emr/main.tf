locals {
    RESOURCE_PREFIX = "femmyte"
}

module "emr" {
  source = "./modules/emr"
  aws_iam_instance_profile_arn = module.iam.aws_iam_instance_profile_arn
  iam_emr_service_role_arn = module.iam.iam_emr_service_role_arn
  aws_subnet_id = module.network.subnet_id
  aws_security_group_id = module.network.aws_security_group_id
  RESOURCE_PREFIX = local.RESOURCE_PREFIX
  depends_on = [ module.network, module.iam ]
  emr_autoscaling_role_arn = module.iam.emr_autoscaling_role_arn
}
module "iam" {
  source = "./modules/iam"
  RESOURCE_PREFIX = local.RESOURCE_PREFIX
}

module "network" {
  source = "./modules/network"
  RESOURCE_PREFIX = local.RESOURCE_PREFIX
}
module "s3" {
  source = "./modules/s3"
}