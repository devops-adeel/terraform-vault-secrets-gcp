output "token" {
  value = vault_approle_auth_backend_login.default.client_token
}

output "url" {
  value = var.vault_address
}

output "namespace" {
  value = "admin/terraform-vault-secrets-gcp/"
}

output "path" {
  value = format("gcp/token/%s-%s", local.env, local.service)
}
