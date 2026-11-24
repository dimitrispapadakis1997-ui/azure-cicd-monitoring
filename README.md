# Azure CI/CD & Monitoring with Terraform

A GitHub Actions pipeline for Terraform on Azure, plus the cost guard rails around it. Authentication uses OIDC, so no secret is stored in GitHub. The state lives in Azure Storage and is shared with the sibling project [azure-network-foundation](https://github.com/dimitrispapadakis1997-ui/azure-network-foundation).

**Status:** 🚧 In progress. See [docs/progress-log.md](docs/progress-log.md).

## What exists so far

- **Monthly budget as code.** `envs/governance` defines a subscription budget (NOK 200 per month) with email alerts at 50% and 90% of actual spend and when the forecast passes 100%.
- **Pipeline.** `.github/workflows/governance.yml` runs format check, init, validate and plan on every pull request and applies on `main`. It has a 15 minute timeout so a hung run fails fast.

## Plan

1. Post the plan as a comment on pull requests.
2. Gate production applies behind a manual approval (GitHub environments).
3. Scan the Terraform code for security problems before apply.
4. Add Azure Monitor alerts.
5. Drift detection on a schedule.

## How it authenticates

The workflow requests a short-lived OIDC token from GitHub and exchanges it for an Azure token. The app registration has one federated credential per trigger (pull request and `main`). Setup steps are in [docs/bootstrap.md](docs/bootstrap.md).

## Cost

The subscription is a free account with a limited credit and is never upgraded to pay-as-you-go, so Azure cannot charge a card. The budget in this repo is the second layer: it warns before the credit is gone.
