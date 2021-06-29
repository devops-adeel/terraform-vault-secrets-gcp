/**
 * Usage:
 *
 * ```hcl
 *
 * module "vault_gcp_secrets" {
 *   source      = "git::https://github.com/devops-adeel/terraform-vault-secrets-gcp.git?ref=v0.7.1"
 *   credentials = var.credentials
 * }
 * ```
 */


resource "vault_gcp_secret_backend" "default" {
  credentials = var.credentials
  description = "GCP Secrets Backend"
}

data "vault_policy_document" "editor" {
  rule {
    path         = "gcp/token/{{identity.entity.metadata.env}}-{{identity.entity.metadata.service}}-editor"
    capabilities = ["read"]
    description  = "Allow generation of Oauth tokens, the end path name is the roleset name"
  }
  rule {
    path         = "auth/token/*"
    capabilities = ["create", "read", "update", "delete", "list"]
    description  = "create child tokens"
  }
}

resource "vault_policy" "editor" {
  name   = "gcp-editor-creds-tmpl"
  policy = data.vault_policy_document.editor.hcl
}

resource "vault_identity_group" "editor" {
  name                       = "gcp-editor-creds"
  type                       = "internal"
  external_policies          = true
  external_member_entity_ids = true
}

resource "vault_identity_group_policies" "editor" {
  group_id  = vault_identity_group.editor.id
  exclusive = true
  policies = [
    "default",
    vault_policy.editor.name,
  ]
}


#####
#
# Rotate Root Credentials
#
#####

data "vault_policy_document" "rotation" {
  rule {
    path         = "gcp/roleset/{{identity.entity.metadata.env}}-{{identity.entity.metadata.service}}/rotate"
    capabilities = ["update"]
    description  = "Rotate SA in order to invalidate oAuth2 token generated"
  }
  rule {
    path         = "gcp/config/rotate-root"
    capabilities = ["update"]
    description  = "Rotate Root Credential"
  }
  rule {
    path         = "auth/token/*"
    capabilities = ["create", "read", "update", "delete", "list"]
    description  = "create child tokens"
  }
}

resource "vault_policy" "rotation" {
  name   = "gcp-rotation"
  policy = data.vault_policy_document.rotation.hcl
}

resource "vault_identity_group" "rotation" {
  name                       = "gcp-rotation"
  type                       = "internal"
  external_policies          = true
  external_member_entity_ids = true
}

resource "vault_identity_group_policies" "rotation" {
  group_id  = vault_identity_group.rotation.id
  exclusive = true
  policies = [
    "default",
    vault_policy.rotation.name,
  ]
}

#####
#
# Inspec Reader Credentials
#
#####

data "vault_policy_document" "reader" {
  rule {
    path         = "gcp/key/*"
    capabilities = ["read"]
    description  = "Allow generation of service-account-keys, the end path name is the roleset name"
  }
}

resource "vault_policy" "reader" {
  name   = "gcp-reader-creds"
  policy = data.vault_policy_document.reader.hcl
}
