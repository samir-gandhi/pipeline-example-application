terraform {
  required_version = ">= 1.6.0"
  backend "s3" {}
}

module "base" {
  source                         = "../base"
  pingone_davinci_admin_username               = var.pingone_davinci_admin_username
  pingone_davinci_admin_password               = var.pingone_davinci_admin_password
  pingone_client_region          = var.pingone_client_region
  pingone_client_id              = var.pingone_client_id
  pingone_client_secret          = var.pingone_client_secret
  pingone_client_environment_id  = var.pingone_client_environment_id
  pingone_davinci_admin_environment_id = var.pingone_davinci_admin_environment_id
  pingone_target_environment_id  = var.pingone_target_environment_id
}
