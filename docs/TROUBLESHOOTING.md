# Troubleshooting Guide

This document records the major technical issues encountered while building the Enterprise Tri-Cloud Analytics Platform and explains how each issue was investigated and resolved.

---

# Table of Contents

1. Docker Architecture Mismatch
2. Incorrect Docker Build Context
3. FastAPI Container Startup Failure
4. ECS Task Deployment Issues
5. Amazon ECR Image Version Confusion
6. ECS Image Digest Mismatch
7. Google BigQuery Authentication
8. CORS Configuration
9. HTTPS and Load Balancer Configuration
10. GitHub Secret Scanning
11. Azure Frontend Integration
12. Lessons Learned

---

# 1. Docker Architecture Mismatch

## Symptoms

The ECS task continuously failed during startup.

CloudWatch logs showed the container exiting immediately.

---

## Root Cause

The Docker image was built for the wrong CPU architecture.

The local build produced an image that did not match the runtime architecture expected by Amazon ECS Fargate.

---

## Investigation

Verified:

- ECS Task Definition
- Runtime Platform
- Docker image architecture
- Container logs

---

## Solution

Rebuilt the Docker image using the correct target platform and pushed a new version to Amazon ECR.

Forced a new ECS deployment.

---

## Prevention

Always verify:

- Docker platform
- ECS runtime architecture
- Task Definition compatibility

before deployment.

---

# 2. Incorrect Docker Build Context

## Symptoms

Expected API endpoints were missing.

Swagger displayed only:

- /
- /health

instead of the complete API.

---

## Root Cause

Docker was packaging the wrong application directory.

The build context referenced an unintended folder.

---

## Solution

Corrected the Docker build context and rebuilt the image.

Verified endpoints locally before deployment.

---

## Prevention

Always verify the Docker context before building production images.

---

# 3. FastAPI Container Startup Failure

## Symptoms

CloudWatch displayed:

```

/bin/sh: [uvicorn,: not found

```

---

## Root Cause

The Docker CMD instruction contained incorrect formatting.

---

## Solution

Updated the Dockerfile to correctly launch Uvicorn.

Rebuilt and redeployed the container.

---

## Prevention

Always test Docker containers locally before pushing to Amazon ECR.

---

# 4. ECS Deployment Issues

## Symptoms

Deployments appeared successful but application behaviour did not change.

---

## Root Cause

Amazon ECS was still running an older container image.

---

## Investigation

Compared:

- ECS Task Definition
- Running Tasks
- Docker Image Digest
- Amazon ECR

---

## Solution

Forced a new ECS deployment after confirming the latest image was available.

---

## Prevention

Always verify:

- Running Task Revision
- Running Image Digest
- Latest ECR Image

after every deployment.

---

# 5. Amazon ECR Image Version Confusion

## Symptoms

Multiple Docker images existed with identical tags.

It became difficult to determine which image ECS was actually running.

---

## Root Cause

Images were repeatedly pushed using the same tag during debugging.

---

## Solution

Verified image digests instead of relying only on tags.

---

## Prevention

Consider semantic version tags in addition to "latest".

Example:

v1.0.0

v1.0.1

latest

---

# 6. ECS Image Digest Mismatch

## Symptoms

The newest Docker image appeared in ECR but ECS continued serving the previous version.

---

## Root Cause

The ECS service had not yet switched to the latest image digest.

---

## Investigation

Compared SHA256 digests between:

- Amazon ECR
- ECS Running Task

---

## Solution

Forced another deployment until ECS referenced the expected digest.

---

## Prevention

Verify image digests whenever deployment behaviour appears inconsistent.

---

# 7. Google BigQuery Authentication

## Symptoms

The backend failed to access Google BigQuery.

---

## Root Cause

The application required Google Service Account credentials inside AWS.

---

## Solution

Stored the Google Service Account JSON securely inside AWS Secrets Manager.

Loaded the credentials during application startup.

---

## Prevention

Never store cloud credentials inside:

- Git repositories
- Docker images
- Source code

---

# 8. CORS Configuration

## Symptoms

The Azure frontend displayed:

```

Backend Offline

```

Browser console showed CORS errors.

---

## Root Cause

The Azure Static Web Apps domain was not included in the FastAPI CORS configuration.

---

## Solution

Added the production frontend origin to the allowed origins list.

Redeployed the backend.

---

## Prevention

Always include production frontend URLs before deployment.

---

# 9. HTTPS Configuration

## Symptoms

Initial backend access required HTTP.

Secure browser access was unavailable.

---

## Solution

Configured:

- AWS Certificate Manager
- Application Load Balancer
- HTTPS Listener
- DNS

The backend became available over HTTPS.

---

## Prevention

Configure HTTPS before exposing production services.

---

# 10. GitHub Secret Scanning

## Symptoms

GitHub rejected repository pushes.

---

## Root Cause

Generated task definition files contained Google credentials.

GitHub Secret Scanning detected sensitive information.

---

## Solution

Removed sensitive files.

Updated .gitignore.

Amended Git history.

Successfully pushed a clean repository.

---

## Prevention

Always review generated deployment files before committing.

---

# 11. Azure Frontend Integration

## Symptoms

Frontend loaded correctly but could not communicate with the backend.

---

## Root Cause

The frontend still referenced localhost during early deployment.

---

## Solution

Updated the frontend API endpoint to the production HTTPS URL.

Redeployed Azure Static Web Apps.

---

## Prevention

Maintain environment-specific configuration for development and production.

---

# Lessons Learned

This project reinforced several key engineering principles.

- Validate locally before deploying.
- Deploy one change at a time.
- Verify Docker images using digests rather than tags.
- Store secrets securely.
- Separate responsibilities across cloud providers.
- Monitor application logs continuously during deployments.
- Document every significant issue and its resolution.

The debugging process demonstrated that successful cloud engineering requires systematic investigation, careful validation, and disciplined deployment practices rather than trial-and-error changes.
