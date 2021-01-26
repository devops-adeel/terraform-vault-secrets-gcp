locals {
  application_name = "terraform-modules-development-gcp"
  env              = "dev"
  service          = "adeel"
}

module "default" {
  source      = "./module"
  entity_ids  = [module.vault_approle.entity_id]
  credentials = var.credentials
}

data "vault_auth_backend" "default" {
  path = "approle"
}

module "vault_approle" {
  source           = "git::https://github.com/devops-adeel/terraform-vault-approle.git?ref=v0.6.1"
  application_name = local.application_name
  env              = local.env
  service          = local.service
  mount_accessor   = data.vault_auth_backend.default.accessor
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

provider "vault" {
  alias     = "default"
  token     = vault_approle_auth_backend_login.default.client_token
  namespace = "admin/terraform-vault-secrets-gcp"
}

data "vault_generic_secret" "default" {
  provider = vault.default
  path     = format("gcp/token/%s-%s", local.env, local.service)
}

provider "google" {
  access_token = data.vault_generic_secret.default.data["token"]
}

resource "google_storage_bucket" "default" {
  name          = "vault-gcp-integration-test"
  location      = "EU"
  force_destroy = true
  lifecycle_rule {
    condition {
      age = 3
    }
    action {
      type = "Delete"
    }
  }
}
