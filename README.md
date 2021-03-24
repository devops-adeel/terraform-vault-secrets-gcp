# Terraform Vault GCP Secrets

This terraform module mounts GCP Secrets backend with an ACL templated policy.
This is designed to run once in a given Vault namespace.  Thereafter GCP
rolesets would be created independently, using the output of this module to
determine the mounted backend path.

## Requirements

GCP SA credentials must be presented as variable with the json contents.  It is
strongly advised to rotate the key immediately after it setup successfully.

```
 $ curl \
    --header "X-Vault-Token: ..." \
    --request POST \
    http://127.0.0.1:8200/v1/gcp/config/rotate-root
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
Usage:

```hcl

module "vault_gcp_secrets" {
  source      = "git::https://github.com/devops-adeel/terraform-vault-secrets-gcp.git?ref=v0.1.0"
  entity_ids = [module.vault_approle.entity_id]
}
```

## Providers

| Name | Version |
|------|---------|
| <a name="provider_vault"></a> [vault](#provider\_vault) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [vault_gcp_secret_backend.default](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/gcp_secret_backend) | resource |
| [vault_identity_entity.default](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_entity) | resource |
| [vault_identity_group.default](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group) | resource |
| [vault_identity_group_policies.default](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group_policies) | resource |
| [vault_policy.default](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy) | resource |
| [vault_identity_entity.default](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/identity_entity) | data source |
| [vault_policy_document.default](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_credentials"></a> [credentials](#input\_credentials) | GCP SA credentials | `string` | n/a | yes |
| <a name="input_entity_ids"></a> [entity\_ids](#input\_entity\_ids) | List of Vault Identity Member IDs | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend_path"></a> [backend\_path](#output\_backend\_path) | Secrets Backend Path as output |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
