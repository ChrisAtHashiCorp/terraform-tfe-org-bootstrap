output "organization" {
  value = tfe_organization.org
}

output "owners_project" {
  value = tfe_project.owners_project
}

output "pmr_project" {
  value = tfe_project.pmr_project
}

output "policies_project" {
  value = tfe_project.policies_project
}

output "vcs_provider" {
  value = tfe_oauth_client.vcs_client
}
