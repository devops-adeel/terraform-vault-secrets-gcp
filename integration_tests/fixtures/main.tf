locals {
  application_name = "terraform-modules-development-gcp"
  env              = "dev"
  service          = "adeel"
}

module "default" {
  source      = "./module"
  credentials = var.credentials
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

resource "vault_gcp_secret_roleset" "roleset" {
  backend      = module.default.backend_path
  roleset      = format("%s-%s", local.env, local.service)
  secret_type  = "access_token"
  project      = var.project
  token_scopes = ["https://www.googleapis.com/auth/cloud-platform"]

  binding {
    resource = "//cloudresourcemanager.googleapis.com/projects/${var.project}"

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
