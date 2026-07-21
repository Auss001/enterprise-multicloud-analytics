# Enterprise Multi-Cloud Operations Analytics Platform

AWS hosts the application core, Google Cloud provides the analytics warehouse, and Azure provides multicloud governance.

## Architecture

- AWS: API, authentication, PostgreSQL and event exports
- Google Cloud: Cloud Storage, BigQuery and Looker Studio
- Azure: Entra ID and Defender for Cloud
- GitHub Actions: OIDC-based infrastructure delivery
