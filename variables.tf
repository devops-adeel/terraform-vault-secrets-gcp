variable "entity_ids" {
  description = "List of Vault Identity Member IDs"
  type        = list(any)
  default     = []
}

variable "credentials" {
  description = "GCP SA credentials"
  type        = string
}
