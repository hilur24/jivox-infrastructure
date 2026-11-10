# Jivox Workload Infrastructure

This repository manages customer infrastructure for the Jivox workload under the AWS MSP Partner Validation Checklist v7.1 compliance standard.

## Architecture & Governance
- **IaC Tooling:** HashiCorp Terraform (AWS Provider)
- **CI/CD Orchestration:** GitHub Actions
- **Static Quality & Linting:** `terraform fmt`, `tflint`
- **Security Static Analysis:** `tfsec`
- **Pre-Production Staging Validation:** Automated dry-run `terraform plan`
- **Segregation of Duties & Gate:** GitHub Environment manual review required before production deployment
- **Rollback SOP:** Documented Git-revert and state restoration procedures

