# Progress log

## 2026-11-24: Budget as code

- **Done:** Defined a monthly subscription budget in Terraform and applied it through GitHub Actions. The budget exists in Azure with email alerts at 50% and 90% of actual spend and on a 100% forecast.
- **Problem:** The work started inside the network project, where it did not belong. A fix to the commit message was not worth rewriting history.
- **Fix:** Moved the governance environment into its own repository. The state key stayed the same, so Terraform keeps managing the same budget and nothing is recreated.

## 2026-11-24: Full pipeline, monitoring and drift detection

- **Done:** One workflow (`terraform.yml`) now runs a security scan, plans both environments, posts the plan as a comment on pull requests, and applies on `main` only after a manual approval in the `production` environment. A second workflow (`drift.yml`) plans every day and fails if real infrastructure differs from the code. A new `envs/monitoring` environment creates an action group and two activity log alerts (resource group deleted, Azure service health).
- **Problem 1:** The security scan failed twice. First the Trivy action tag did not exist, then Trivy could not be installed on the runner.
- **Fix 1:** Switched the scan to Checkov, installed with pip, which is more reliable on hosted runners.
- **Problem 2:** The approved apply failed with `AADSTS700213`. A job that uses an environment presents a different OIDC subject (`...:environment:production`), so it needs its own federated credential. After adding it, the first attempt still failed because Entra had not propagated it yet.
- **Fix 2:** Added the credential, waited a few minutes and re-ran the failed job. It applied cleanly, and the governance plan showed no changes.
- **Lesson:** Saving the plan in the plan job and applying that exact file after approval means what gets applied is what was reviewed.
