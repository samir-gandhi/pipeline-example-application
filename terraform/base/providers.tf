terraform {
  required_version = ">= 1.6.0"
  required_providers {
    pingone = {
      source  = "pingidentity/pingone"
      version = ">= 0.27.0, < 1.0.0"
    }
    davinci = {
      source  = "pingidentity/davinci"
      version = ">= 0.2.1, < 1.0.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

##########################################################################
# main.tf - Declarations for modules and providers to 
# create infrastructure.
# {@link https://developer.hashicorp.com/terraform/language/modules}
# {@link https://developer.hashicorp.com/terraform/language/providers}
##########################################################################

##############################################
# PingOne Module
##############################################

# PingOne Environment Module
# {@link https://registry.terraform.io/modules/terraform-pingidentity-modules/environment/pingone/latest?tab=inputs}

# PingOne Utilities Module
# {@link https://registry.terraform.io/modules/pingidentity/utils/pingone/latest}
module "pingone_utils" {
  source  = "pingidentity/utils/pingone"
  version = "0.0.8"

  environment_id = var.pingone_target_environment_id
  region         = var.pingone_client_region
}

##############################################
# PingOne Provider
##############################################
# {@link https://registry.terraform.io/providers/pingidentity/pingone/latest/docs}

provider "pingone" {
  client_id      = var.pingone_client_id
  client_secret  = var.pingone_client_secret
  environment_id = var.pingone_client_environment_id
  region         = var.pingone_client_region
}

##############################################
# PingOne DaVinci Provider
##############################################
# {@link https://registry.terraform.io/providers/pingidentity/davinci/latest/docs}

provider "davinci" {
  username       = var.pingone_davinci_admin_username
  password       = var.pingone_davinci_admin_password
  region         = var.pingone_client_region
  environment_id = var.pingone_davinci_admin_environment_id
}
