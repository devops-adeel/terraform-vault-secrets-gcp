## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_vault"></a> [vault](#provider\_vault) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_default"></a> [default](#module\_default) | ./module |  |
| <a name="module_vault_approle"></a> [vault\_approle](#module\_vault\_approle) | git::https://github.com/devops-adeel/terraform-vault-approle.git?ref=v0.7.0 |  |

## Resources

| Name | Type |
|------|------|
| [vault_approle_auth_backend_login.default](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/approle_auth_backend_login) | resource |
| [vault_gcp_secret_roleset.roleset](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/gcp_secret_roleset) | resource |
| [vault_auth_backend.default](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/auth_backend) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_approle_id"></a> [approle\_id](#input\_approle\_id) | n/a | `any` | n/a | yes |
| <a name="input_approle_secret"></a> [approle\_secret](#input\_approle\_secret) | n/a | `any` | n/a | yes |
| <a name="input_credentials"></a> [credentials](#input\_credentials) | Json credentials of gcp sa | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Google Project ID. | `string` | n/a | yes |
| <a name="input_vault_address"></a> [vault\_address](#input\_vault\_address) | Vault Address | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_namespace"></a> [namespace](#output\_namespace) | Vault Namespace |
| <a name="output_path"></a> [path](#output\_path) | Vault API Endpoint |
| <a name="output_token"></a> [token](#output\_token) | Vault Client Token |
| <a name="output_url"></a> [url](#output\_url) | Vault URL Address |
