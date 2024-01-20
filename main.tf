#
# Create Org, VCS Provider, and set Global Variable Set for Org name
#

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

resource "tfe_variable_set" "global_var_set" {
  name         = "Global Variables"
  description  = "Global variable set to house things such as the VCS token ID."
  organization = tfe_organization.org.id
  global       = true
}

resource "tfe_variable" "vcs_token_id" {
  key             = "org_name"
  value           = tfe_organization.org.name
  category        = "terraform"
  description     = "The name of the current Org"
  variable_set_id = tfe_variable_set.global_var_set.id
}

#
# Create the Owner's Project and set Owner Team TFE token in Project var set
#

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

#
# Configure the Project and Team for manipulating the PMR
#

module "pmr" {
  source  = "ChrisAtHashiCorp/env-builder/tfe"
  
  org_name = tfe_organization.org.id
  env_name = "pmr"
  access = {
    organization_access = {
      manage_providers = true
      manage_modules = true
    }
  }
}

#
# Create the Project and Team for manipulating Policies and Run Tasks
#

module "policies" {
  source  = "ChrisAtHashiCorp/env-builder/tfe"
  
  org_name = tfe_organization.org.id
  env_name = "policies"
  access = {
    organization_access = {
      manage_policies = true
      manage_run_tasks = true
    }
  }
}

#
# Environment Generator
# This will create Projects and Teams for different environments, such as {dev,qa,prod}.
# Basically, it will create an
#
