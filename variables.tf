variable "tfe_token" {
  type = string
  description = "TFE provider token (owners team)"
  sensitive = true
}

variable "org_name" {
  type        = string
  description = "Name of the Organization to bootstrap."
}

variable "org_owner" {
  type        = string
  description = "Email of the account that will own the Organization"
}

variable "root_project" {
  type        = string
  description = "Name of the root project that will hold the Workspaces containing the Org."
  default     = "root"
}

variable "vcs_client_name" {
  type        = string
  description = "Name of the VCS OAUTH client."
  default     = "GitHub.com"
}

variable "vcs_client_api_url" {
  type        = string
  description = "API URL for the OAUTH VCS client"
  default     = "https://api.github.com"
}

variable "vcs_client_http_url" {
  type        = string
  description = "HTTP URL for the OAUTH VCS client."
  default     = "https://github.com"
}

variable "vcs_oauth_token" {
  type        = string
  sensitive   = true
  description = "OAUTH token for VCS client."
}

variable "vcs_provider" {
  type        = string
  description = "The VCS provider being connected to. Defaults to github.com."
  default     = "github"
}

variable "org_workspace_name" {
  type        = string
  description = "Name of the Workspace that will hold the state for the Org."
  default     = "root"
}

variable "modules_project_name" {
  type        = string
  description = "Name of the project that will hold the Workspace(s) containing code to manage the PMR."
  default     = "modules"
}

variable "modules_team_name" {
  type        = string
  description = "Name of the team that will have access to the Project for managing the PMR."
  default     = "modules"
}

variable "policies_project_name" {
  type        = string
  description = "Name of the project that will hold the Workspaces(s) containing code to manage policies."
  default     = "policies"
}

variable "policies_team_name" {
  type        = string
  description = "Name of the team that will have access to the Project for managing policy sets."
  default     = "policies"
}

