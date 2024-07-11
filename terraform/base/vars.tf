variable "pingone_davinci_admin_username" {
  type = string
}
variable "pingone_davinci_admin_password" {
  type = string
}
variable "pingone_client_region" {
  type = string
}
variable "pingone_client_id" {
  type = string
}
variable "pingone_client_secret" {
  type = string
}
variable "pingone_client_environment_id" {
  type = string
}
variable "pingone_davinci_admin_environment_id" {
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
variable "pingone_target_environment_id" {
  type        = string
  description = "The target environment id to deploy the application to"
}