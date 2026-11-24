# Progress log

## 2026-11-24: Budget as code

- **Done:** Defined a monthly subscription budget in Terraform and applied it through GitHub Actions. The budget exists in Azure with email alerts at 50% and 90% of actual spend and on a 100% forecast.
- **Problem:** The work started inside the network project, where it did not belong. A fix to the commit message was not worth rewriting history.
- **Fix:** Moved the governance environment into its own repository. The state key stayed the same, so Terraform keeps managing the same budget and nothing is recreated.
- **Next:** Federated credentials and variables for this repository, then plan comments on pull requests.
