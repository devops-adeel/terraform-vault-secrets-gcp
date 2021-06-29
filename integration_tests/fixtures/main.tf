locals {
  application_name = "terraform-modules-development-gcp"
  env              = "dev"
  service          = "web"
  account_id       = "gcp-vault-secrets-backend"
}

data "google_project" "default" {}

resource "google_service_account" "default" {
  account_id   = local.account_id
  display_name = "Vault GCP Secrets Backend"
  description  = "Service Account for Vault GCP Secrets Backend Mount"
}

resource "google_service_account_key" "default" {
  service_account_id = google_service_account.default.name
}

resource "google_project_iam_member" "default" {
  project = data.google_project.default.project_id
  role    = "roles/owner"
  member  = format("serviceAccount:%s", google_service_account.default.email)
}

module "default" {
  source      = "./module"
  credentials = base64decode(google_service_account_key.default.private_key)
}

data "vault_auth_backend" "default" {
  path = "approle"
}

module "vault_approle" {
  source            = "git::https://github.com/devops-adeel/terraform-vault-approle.git?ref=v0.7.0"
  application_name  = local.application_name
  env               = local.env
  service           = local.service
  mount_accessor    = data.vault_auth_backend.default.accessor
  identity_group_id = module.default.identity_group_id
}

resource "vault_gcp_secret_roleset" "non_prod" {
  backend      = module.default.backend_path
  roleset      = format("editor-%s-%s", local.env, local.service)
  secret_type  = "access_token"
  project      = google_project_iam_member.default.project
  token_scopes = ["https://www.googleapis.com/auth/cloud-platform"]

  binding {
    resource = "//cloudresourcemanager.googleapis.com/${data.google_project.default.id}"

    roles = [
      "roles/storage.admin",
    ]
  }
}

resource "vault_gcp_secret_roleset" "prod" {
  backend      = module.default.backend_path
  roleset      = "editor-prod-db"
  secret_type  = "access_token"
  project      = google_project_iam_member.default.project
  token_scopes = ["https://www.googleapis.com/auth/cloud-platform"]

  binding {
    resource = "//cloudresourcemanager.googleapis.com/${data.google_project.default.id}"

    roles = [
      "roles/storage.admin",
    ]
  }
}

resource "vault_approle_auth_backend_login" "default" {
  backend   = module.vault_approle.backend_path
  role_id   = module.vault_approle.approle_id
  secret_id = module.vault_approle.approle_secret
}

#####
#
# Rotate Root Credentials
#
#####

module "rotation_approle" {
  source            = "git::https://github.com/devops-adeel/terraform-vault-approle.git?ref=v0.7.0"
  application_name  = "root-rotation"
  env               = local.env
  service           = "root"
  mount_accessor    = data.vault_auth_backend.default.accessor
  identity_group_id = module.default.rotation_group_id
}

resource "vault_approle_auth_backend_login" "rotation" {
  backend   = module.rotation_approle.backend_path
  role_id   = module.rotation_approle.approle_id
  secret_id = module.rotation_approle.approle_secret
}
