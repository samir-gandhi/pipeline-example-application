variable "pingone_davinci_admin_username" {
  default = ""
  type    = string
}
variable "pingone_davinci_admin_password" {
  default = ""
  type    = string
}
variable "pingone_client_region" {
  default = ""
  type    = string
}
variable "pingone_client_id" {
  default = ""
  type    = string
}
variable "pingone_client_secret" {
  default = ""
  type    = string
}
variable "pingone_client_environment_id" {
  default = ""
  type    = string
}
variable "pingone_davinci_admin_environment_id" {
  default = ""
  type    = string
}
variable "pingone_target_environment_id" {
  type        = string
  description = "The target environment id to deploy the application to"
}