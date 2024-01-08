# Create Org and VCS Provider

resource "tfe_organization" "org" {
  name  = var.org_name
  email = var.org_owner
}

resource "tfe_oauth_client" "vcs_client" {
  name             = var.vcs_client_name
  organization     = tfe_organization.org.name
  api_url          = var.vcs_client_api_url
  http_url         = var.vcs_client_http_url
  oauth_token      = var.vcs_oauth_token
  service_provider = var.vcs_provider
}

# Create the Owner's Project and set Owner Team TFE token in Project var set

data "tfe_team" "owners" {
  name         = "owners"
  organization = tfe_organization.org.id
}

resource "tfe_project" "owners_project" {
  organization = tfe_organization.org.name
  name         = var.owners_project
}

resource "tfe_team_token" "owners_team_token" {
  team_id = data.tfe_team.owners.id
}

resource "tfe_variable_set" "owners_variable_set" {
  name         = "Owners"
  description  = "Variable set for the Owner's Team."
  organization = tfe_organization.org.name
}

resource "tfe_project_variable_set" "owners_project_variable_set" {
  variable_set_id = tfe_variable_set.owners_variable_set.id
  project_id      = tfe_project.owners_project.id
}

resource "tfe_variable" "owner_team_token" {
  key             = "TFE_TOKEN"
  value           = tfe_team_token.owners_team_token.token
  sensitive       = true
  category        = "env"
  variable_set_id = tfe_variable_set.owners_variable_set.id
  description     = "The Owner's Team TFE Token"
}

resource "tfe_variable" "vcs_oauth_token" {
  key             = "vcs_oauth_token"
  value           = var.vcs_oauth_token
  sensitive       = true
  category        = "terraform"
  variable_set_id = tfe_variable_set.owners_variable_set.id
  description     = "The VCS OAUTH setup token."
}

# Configure the Project and Team for manipulating the PMR

resource "tfe_project" "pmr_project" {
  organization = tfe_organization.org.name
  name         = var.pmr_project_name
}

resource "tfe_team" "pmr_team" {
  name         = var.pmr_team_name
  organization = tfe_organization.org.name
  organization_access {
    manage_providers = true
    manage_modules   = true
  }
}

resource "tfe_variable_set" "pmr_variable_set" {
  name         = "PMR"
  description  = "Variable set for the PMR's Team."
  organization = tfe_organization.org.name
}

resource "tfe_project_variable_set" "pmr_project_variable_set" {
  variable_set_id = tfe_variable_set.pmr_variable_set.id
  project_id      = tfe_project.pmr_project.id
}

resource "tfe_team_token" "pmr_team_token" {
  team_id = tfe_team.pmr_team.id
}

resource "tfe_variable" "pmr_team_token" {
  key             = "TFE_TOKEN"
  value           = tfe_team_token.pmr_team_token.token
  sensitive       = true
  category        = "env"
  variable_set_id = tfe_variable_set.pmr_variable_set.id
  description     = "The Owner's Team TFE Token"
}

# Create the Project and Team for manipulating policies

resource "tfe_project" "policies_project" {
  organization = tfe_organization.org.name
  name         = var.policies_project_name
}

resource "tfe_team" "policies_team" {
  name         = var.policies_team_name
  organization = tfe_organization.org.name
  organization_access {
    manage_policies = true
  }
}

resource "tfe_variable_set" "policies_variable_set" {
  name         = "Policies"
  description  = "Variable set for the Policies's Team."
  organization = tfe_organization.org.name
}

resource "tfe_project_variable_set" "policies_project_variable_set" {
  variable_set_id = tfe_variable_set.policies_variable_set.id
  project_id      = tfe_project.policies_project.id
}

resource "tfe_team_token" "policies_team_token" {
  team_id = tfe_team.policies_team.id
}

resource "tfe_variable" "policies_team_token" {
  key             = "TFE_TOKEN"
  value           = tfe_team_token.policies_team_token.token
  sensitive       = true
  category        = "env"
  variable_set_id = tfe_variable_set.policies_variable_set.id
  description     = "The Policies's Team TFE Token"
}
