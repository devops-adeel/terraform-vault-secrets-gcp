output "backend_path" {
  description = "Secrets Backend Path as output"
  value       = vault_gcp_secret_backend.default.path
}
