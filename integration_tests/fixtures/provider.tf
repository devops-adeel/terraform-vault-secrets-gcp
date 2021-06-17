terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
    }
  }
  backend "remote" {
    organization = "hc-implementation-services"

    workspaces {
      name = "terraform-vault-secrets-gcp"
    }
  }
}

variable "approle_id" {}
variable "approle_secret" {}

provider "vault" {
  auth_login {
    namespace = "vault_namespace"
    path = "auth/approle/login"

    parameters = {
      role_id   = var.approle_id
      secret_id = var.approle_secret
    }
  }
}

