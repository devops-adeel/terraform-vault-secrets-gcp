variable "entity_ids" {
  description = "List of Vault Identity Member IDs"
  type        = list(string)
  default     = []
}

variable "credentials" {
  description = "GCP SA credentials"
  type        = string
  sensitive = true
}
