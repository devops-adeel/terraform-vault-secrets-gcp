output "token" {
  description = "Vault Client Token"
  value       = vault_approle_auth_backend_login.default.client_token
}

output "url" {
  description = "Vault URL Address"
  value       = var.vault_address
}

output "namespace" {
  description = "Vault Namespace"
  value       = "admin/terraform-vault-secrets-gcp/"
}

output "path" {
  description = "Vault API Endpoint"
  value       = format("gcp/token/%s-%s", local.env, local.service)
}

output "rotation_token" {
  description = "Vault Client Token for root credential rotation"
  value       = vault_approle_auth_backend_login.rotation.client_token
}

output "rotation_path" {
  description = "Vault API Endpoint root credential rotation"
  value       = "gcp/config/rotate-root"
}
