/**
 * Usage:
 *
 * ```hcl
 *
 * module "vault_gcp_secrets" {
 *   source      = "git::https://github.com/devops-adeel/terraform-vault-secrets-gcp.git?ref=v0.5.0"
 * }
 * ```
 */


locals {
  secret_type = "gcp"
}

resource "vault_gcp_secret_backend" "default" {
  credentials = var.credentials
  description = "GCP Secrets Backend"
}

data "vault_policy_document" "default" {
  rule {
    path         = "${local.secret_type}/+/{{identity.entity.metadata.env}}-{{identity.entity.metadata.service}}"
    capabilities = ["read"]
    description  = "Allow generation of Oauth tokens, the end path name is the roleset name"
  }
  rule {
    path         = "auth/token/*"
    capabilities = ["create", "read", "update", "delete", "list"]
    description  = "create child tokens"
  }
}

resource "vault_policy" "default" {
  name   = "${local.secret_type}-creds-tmpl"
  policy = data.vault_policy_document.default.hcl
}

resource "vault_identity_group" "default" {
  name                       = "${local.secret_type}-creds"
  type                       = "internal"
  external_policies          = true
  external_member_entity_ids = true
}

resource "vault_identity_group_policies" "default" {
  group_id  = vault_identity_group.default.id
  exclusive = true
  policies = [
    "default",
    vault_policy.default.name,
  ]
}
