terraform {
  required_version = ">= 1.5.0"
}

provider "tfe" {
  token = var.tfe_token
}
