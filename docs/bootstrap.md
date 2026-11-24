# Bootstrap

This project reuses the identity and the state storage created for [azure-network-foundation](https://github.com/dimitrispapadakis1997-ui/azure-network-foundation/blob/main/docs/bootstrap.md). Only the repository-specific parts are new.

## Added for this repository

| Item | Value |
|---|---|
| Federated credential (main) | `repo:<owner>@<owner_id>/azure-cicd-monitoring@<repo_id>:ref:refs/heads/main` |
| Federated credential (pull request) | `repo:<owner>@<owner_id>/azure-cicd-monitoring@<repo_id>:pull_request` |

GitHub puts the immutable owner and repository IDs into the OIDC subject. A credential in the classic `repo:owner/name` format is rejected with `AADSTS700213`.

## Repository variables

| Variable | Value |
|---|---|
| `AZURE_CLIENT_ID` | Application (client) ID of the shared app registration |
| `AZURE_TENANT_ID` | Directory (tenant) ID |
| `AZURE_SUBSCRIPTION_ID` | Subscription ID |
| `TFSTATE_RESOURCE_GROUP` | `rg-tfstate` |
| `TFSTATE_STORAGE_ACCOUNT` | The state storage account name |
| `ALERT_EMAIL` | Address that receives budget alerts |
