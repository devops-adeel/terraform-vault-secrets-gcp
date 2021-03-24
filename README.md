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
## Providers

| Name    | Version   |
| ------  | --------- |
| `vault` | n/a       |

## Modules

No Modules.

## Resources

| Name                                                                                                                                   |
| ------                                                                                                                                 |
| [vault_gcp_secret_backend](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/gcp_secret_backend)           |
| [vault_identity_entity](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/identity_entity)              |
| [vault_identity_entity](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_entity)                 |
| [vault_identity_group](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group)                   |
| [vault_identity_group_policies](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group_policies) |
| [vault_policy](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy)                                   |
| [vault_policy_document](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/policy_document)              |

## Inputs

| Name          | Description                       | Type        | Default   | Required   |
| ------        | -------------                     | ------      | --------- | :--------: |
| `credentials` | GCP SA credentials                | `string`    | n/a       | yes        |
| `entity_ids`  | List of Vault Identity Member IDs | `list(any)` | `[]`      | no         |

## Outputs

| Name           | Description                    |
| ------         | -------------                  |
| `backend_path` | Secrets Backend Path as output |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
