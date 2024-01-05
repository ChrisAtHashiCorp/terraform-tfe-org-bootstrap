output "id" {
  value = tfe_organization.org.id
}

output "name" {
  value = tfe_organization.org.name
}

output "vcs_oauth_token_id" {
  value = tfe_oauth_client.vcs_client.oauth_token_id
}

output "root_project" {
  value = tfe_project.root_project.id
}
