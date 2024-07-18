#########################################################################
# PingOne DaVinci - Create and deploy a flow
#########################################################################
# {@link https://registry.terraform.io/providers/pingidentity/davinci/latest/docs/resources/flow}

resource "davinci_flow" "registration_flow" {
  flow_json = file("./davinci_flows/davinci-api-reg-authn-flow.json")

  environment_id = var.pingone_target_environment_id

  connection_link {
    id                           = element([for s in data.davinci_connections.read_all.connections : s.id if s.name == "Http"], 0)
    name                         = element([for s in data.davinci_connections.read_all.connections : s.name if s.name == "Http"], 0)
    replace_import_connection_id = "867ed4363b2bc21c860085ad2baa817d"
  }

  connection_link {
    id                           = element([for s in data.davinci_connections.read_all.connections : s.id if s.name == "PingOne"], 0)
    name                         = element([for s in data.davinci_connections.read_all.connections : s.name if s.name == "PingOne"], 0)
    replace_import_connection_id = "94141bf2f1b9b59a5f5365ff135e02bb"
  }
  connection_link {
    id                           = element([for s in data.davinci_connections.read_all.connections : s.id if s.name == "Annotation"], 0)
    name                         = element([for s in data.davinci_connections.read_all.connections : s.name if s.name == "Annotation"], 0)
    replace_import_connection_id = "921bfae85c38ed45045e07be703d86b8"

  }
}

#########################################################################
# PingOne DaVinci - Create an application and flow policy for the flow above
#########################################################################
# {@link https://registry.terraform.io/providers/pingidentity/davinci/latest/docs/resources/application}
locals {
  is_north_america = (var.pingone_client_region_code == "NORTHAMERICA" || var.pingone_client_region_code == "NA" || var.pingone_client_region_code == "COM")
  is_europe        = (var.pingone_client_region_code == "EUROPE" || var.pingone_client_region_code == "EU")
  is_canada        = (var.pingone_client_region_code == "CANADA" || var.pingone_client_region_code == "CA")
  is_asia_pacific  = (var.pingone_client_region_code == "ASIAPACIFIC" || var.pingone_client_region_code == "AP" || var.pingone_client_region_code == "ASIA")

  ###########################################
  # Domain Suffixes
  ###########################################
  pingone_domain_suffix_north_america = local.is_north_america ? "com" : ""
  pingone_domain_suffix_europe        = local.is_europe ? "eu" : ""
  pingone_domain_suffix_canada        = local.is_canada ? "ca" : ""
  pingone_domain_suffix_asia_pacific  = local.is_asia_pacific ? "asia" : ""
  pingone_domain_suffix               = coalesce(local.pingone_domain_suffix_north_america, local.pingone_domain_suffix_europe, local.pingone_domain_suffix_canada, local.pingone_domain_suffix_asia_pacific)
  custom_domain                       = ""
  pingone_url_auth_domain             = coalesce(local.custom_domain, format("auth.pingone.%s", local.pingone_domain_suffix))
  pingone_url_auth_path               = format("https://%s", local.pingone_url_auth_domain)
  pingone_url_auth_path_full          = local.custom_domain != "" ? local.pingone_url_auth_path : format("%s/%s", local.pingone_url_auth_path, var.pingone_target_environment_id)
}

resource "davinci_application" "registration_flow_app" {
  name           = "DaVinci API Registration Sample Application"
  environment_id = var.pingone_target_environment_id
  depends_on     = [data.davinci_connections.read_all]
  oauth {
    enabled = true
    values {
      allowed_grants                = ["authorizationCode"]
      allowed_scopes                = ["openid", "profile"]
      enabled                       = true
      enforce_signed_request_openid = false
      redirect_uris                 = ["${local.pingone_url_auth_path_full}/rp/callback/openid_connect"]
    }
  }
}

resource "davinci_application_flow_policy" "registration_flow_app_policy" {
  environment_id = var.pingone_target_environment_id
  application_id = davinci_application.registration_flow_app.id
  name           = "DaVinci API Registration Sample Policy"
  status         = "enabled"
  policy_flow {
    flow_id    = davinci_flow.registration_flow.id
    version_id = -1
    weight     = 100
  }
}

resource "local_file" "env_config" {
  content  = "window._env_ = {\n  pingOneDomain: \"${local.pingone_domain_suffix}\",\n  companyId: \"${davinci_application.registration_flow_app.environment_id}\",\n  apiKey: \"${davinci_application.registration_flow_app.api_keys.prod}\",\n  policyId: \"${davinci_application_flow_policy.registration_flow_app_policy.id}\"\n};"
  filename = "./sample-app/global.js"
}

output "env_config" {
  value = local_file.env_config.content
}

# Define a Docker image resource
resource "docker_image" "registration" {
  name = "simple-registration:latest"
  build {
    # Path to the directory containing Dockerfile and other necessary files
    context = "./sample-app"
  }
  # triggers = {
  #   dir_sha1 = sha1(join("", [for f in fileset(path.cwd, ".sample-app/**"): filesha1("${path.cwd}/${f}")]))
  #   # dir_sha1 = sha1(join("", [for f in fileset(path.module, "../base"): filesha1(f)]))
  #   # dir_sha1 = sha1("abc1234")
  # }
  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(path.module, "./sample-app/**") : filesha1(f)]))
  }
  force_remove = true
  depends_on   = [local_file.env_config]
}

# Define a Docker container resource
resource "docker_container" "registration" {
  name  = "simple-registration"
  image = docker_image.registration.image_id
  ports {
    internal = 443
    external = 1443
  }
  ports {
    internal = 8080
    external = 8080
  }
  rm = true
}

output "dir_sha1" {
  value = docker_image.registration.triggers.dir_sha1
}