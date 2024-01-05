# Create the Org and the root Project

resource "tfe_organization" "org" {
  name  = var.org_name
  email = var.org_owner
}

resource "tfe_project" "root_project" {
  organization = tfe_organization.org.name
  name         = var.root_project
}

# Configure the VCS Provider 

resource "tfe_oauth_client" "vcs_client" {
  name             = var.vcs_client_name
  organization     = tfe_organization.org.name
  api_url          = var.vcs_client_api_url
  http_url         = var.vcs_client_http_url
  oauth_token      = var.vcs_oauth_token
  service_provider = var.vcs_provider
}

# Configure the Project and Team for manipulating the PMR

resource "tfe_project" "modules_project" {
  organization = tfe_organization.org.name
  name         = var.modules_project_name
}

resource "tfe_team" "modules_team" {
  name         = var.modules_team_name
  organization = tfe_organization.org.name
}

# Create the Project and Team for manipulating policies

resource "tfe_project" "policies_project" {
  organization = tfe_organization.org.name
  name         = var.policies_project_name
}

resource "tfe_team" "policies_team" {
  name         = var.policies_team_name
  organization = tfe_organization.org.name
}

# Get owner team token

data "tfe_team" "owners" {
  name         = "owners"
  organization = tfe_organization.org.id
}

resource "tfe_team_token" "owner_team_token" {
  team_id = data.tfe_team.owners.id
}

resource "tfe_variable_set" "owners_variable_set" {
  name         = "Owners"
  description  = "Variable set for the Owner's Team."
  organization = tfe_organization.org.name
}

resource "tfe_project_variable_set" "owners_project_variable_set" {
  variable_set_id = tfe_variable_set.owners_variable_set.id
  project_id      = tfe_project.root_project.id
}

resource "tfe_variable" "owner_team_token" {
  key = "tfe_token"
  value = var.tfe_token
  sensitive = true
  category = "terraform"
  variable_set_id = tfe_variable_set.owners_variable_set.id
  description = "The Owner's Team TFE Token"
}

resource "tfe_variable" "vcs_oauth_token" {
  key = "vcs_oauth_token"
  value = var.vcs_oauth_token
  sensitive = true
  category = "terraform"
  variable_set_id = tfe_variable_set.owners_variable_set.id
  description = "VCS OAUTH Token"
}

resource "tfe_workspace" "root" {
  name = "root"
  organization = tfe_organization.org.id
  project_id = tfe_project.root_project.id

  vcs_repo {
    identifier = "ChrisAtHashiCorp/moad"
    oauth_token_id = tfe_oauth_client.vcs_client.oauth_token_id
  }
  working_directory = "bootstrap"
}

