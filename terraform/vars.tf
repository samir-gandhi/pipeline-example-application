##########################################################################
# vars.tf - Contains declarations of variables and locals.
# {@link https://developer.hashicorp.com/terraform/language/values}
##########################################################################
# "region" in the BX repo
variable "pingone_region" {
  type = string
  description = "Region in which your P1 Org is located"
}

# "license_id" in the BX repo
variable "pingone_license_id" {
  type = string
  description = "Id of the P1 license to be assigned to the environment"
}

# "pingone_environment_id" in the BX repo
variable "pingone_davinci_environment_id" {
  type = string
  description = "Id of the P1 admin environment"
}

# User Id for a user in the DaVinci Administrators Environment
# Located under Directory -> Users -> Select user -> Click API tab -> ID
variable "admin_user_id" {
  type = string
  description = "PingOne userID to grant i dentity admin role for new environment"
}

# Client Id for Worker App in the DaVinci Administrators Environment
# Located under Connections -> Applications -> Select existing Worker App or create one -> Configuration -> Expand General -> Client ID
# I have this in my Administrators environment
variable "worker_id" {
  type        = string
  description = "Worker App ID App - App must have sufficient Roles"
  sensitive   = true
}

# Client Secret for Worker App in the DaVinci Administrators Environment
# Located under Connections -> Applications -> Select Worker App -> Configuration -> Expand General -> Client Secret
variable "worker_secret" {
  type        = string
  description = "Worker App Secret - App must have sufficient Roles"
  sensitive   = true
}

# "env_name" in the BX repo
variable "pingone_environment_name" {
  description = "Name that was used to create the PingOne Environment in which the application will be deployed"
  type        = string
}

# Username for DaVinci admin user 
variable "admin_username" {
  type        = string
  description = "Username to use for the DaVinci provider"
}

# Password for DaVinci admin user
variable "admin_password" {
  type        = string
  description = "Password to use for the DaVinci provider"
}
#### end of vars from BX repo ####

#### possible vars for use with pipeline ####
variable "pingone_environment_type" {
  type = string
}
variable "pingone_force_delete_environment" {
  description = "This option should not be used in environments that contain production data.  Data loss may occur."
  default     = false
  type        = bool
}
variable "pingone_force_delete_population" {
  description = "This option should not be used in environments that contain production data.  Data loss may occur."
  default     = false
  type        = bool
}