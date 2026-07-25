# Architecture Decisions

## Purpose

This document explains the major architectural decisions made during the design and implementation of the Enterprise Tri-Cloud Analytics Platform.

Each technology and cloud service was selected intentionally to demonstrate practical cloud engineering skills and production-style design principles.

---

# Why Multi-Cloud?

Instead of deploying every component into a single cloud provider, this project distributes responsibilities across Azure, AWS, and Google Cloud.

Benefits include:

- Demonstrates interoperability between cloud platforms
- Reduces dependency on a single provider
- Highlights the strengths of each platform
- Reflects architectures used by many enterprise organizations

---

# Why Azure Static Web Apps?

Azure Static Web Apps was selected for the frontend because it provides:

- Simple deployment from GitHub
- Automatic HTTPS
- Global content delivery
- Minimal operational overhead

Since the frontend is a static HTML, CSS, and JavaScript application, a managed static hosting service is an appropriate choice.

---

# Why Amazon ECS Fargate?

Amazon ECS Fargate was chosen for the backend because it allows containers to run without managing virtual machines.

Benefits include:

- No server management
- Managed container orchestration
- Integration with AWS networking and security
- Simple scaling

---

# Why Docker?

Docker provides a consistent runtime environment across development and production.

Benefits include:

- Reproducible builds
- Environment consistency
- Easy deployment
- Cloud portability

---

# Why FastAPI?

FastAPI was selected because it provides:

- High performance
- Automatic OpenAPI documentation
- Modern Python features
- Built-in validation

The automatic Swagger UI also simplifies API testing.

---

# Why Google BigQuery?

BigQuery was selected to demonstrate cross-cloud data integration.

Benefits include:

- Managed analytics platform
- SQL-based querying
- Minimal operational management
- Excellent performance for analytical workloads

---

# Why AWS Secrets Manager?

Google Cloud credentials are stored in AWS Secrets Manager instead of inside the application.

This improves security by:

- Avoiding hardcoded credentials
- Keeping secrets out of Git repositories
- Allowing secure runtime access
- Simplifying credential rotation

---

# Why HTTPS?

All production communication uses HTTPS.

Benefits include:

- Encryption in transit
- Browser trust
- Protection against interception
- Production-ready security

TLS certificates are managed using AWS Certificate Manager.

---

# Why an Application Load Balancer?

The Application Load Balancer provides:

- HTTPS termination
- Request routing
- Health checks
- Future scalability

Although a single backend container is currently deployed, the ALB allows the architecture to grow without redesign.

---

# Why CloudWatch?

CloudWatch provides centralized logging for the backend.

Benefits include:

- Deployment troubleshooting
- Runtime diagnostics
- Application monitoring
- Operational visibility

---

# Summary

Every component in the platform was selected to demonstrate practical cloud engineering principles rather than simply to make the application work.

The architecture emphasizes:

- Security
- Scalability
- Maintainability
- Clear separation of responsibilities
- Enterprise deployment practices