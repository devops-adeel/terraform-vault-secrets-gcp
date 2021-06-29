output "backend_path" {
  description = "Secrets Backend Path as output"
  value       = vault_gcp_secret_backend.default.path
}

output "identity_group_id" {
  description = "ID of the created Vault Identity Group."
  value       = vault_identity_group.editor.id
  sensitive   = true
}

output "rotation_group_id" {
  description = "ID for rotation identity group"
  value       = vault_identity_group.rotation.id
  sensitive   = true
}

output "reader_policy_name" {
  description = "The name of the GCP Reader Policy"
  value       = vault_policy.reader.name
}
