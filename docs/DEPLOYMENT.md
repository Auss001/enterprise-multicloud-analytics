# Deployment Guide

## Overview

This document describes the deployment process for the Enterprise Tri-Cloud Analytics Platform.

The application is deployed across three cloud providers:

- Microsoft Azure (Frontend)
- Amazon Web Services (Backend)
- Google Cloud Platform (Analytics Database)

---

# Prerequisites

Before deployment, ensure the following tools are installed:

- Git
- Docker Desktop
- Python 3.12+
- Azure CLI
- AWS CLI
- Google Cloud SDK
- Terraform (optional)

---

# Clone Repository

```bash
git clone https://github.com/YOUR_USERNAME/enterprise-tri-cloud-analytics.git

cd enterprise-tri-cloud-analytics
```

---

# Backend Deployment

## Build Docker Image

```bash
docker build -t backend .
```

---

## Test Locally

```bash
docker run -p 8000:8000 backend
```

Verify:

```
http://localhost:8000/docs
```

---

## Push to Amazon ECR

Authenticate:

```bash
aws ecr get-login-password ...
```

Tag image:

```bash
docker tag backend:latest ...
```

Push:

```bash
docker push ...
```

---

# Amazon ECS

Create or update:

- Task Definition
- ECS Service

Force a new deployment.

Confirm:

- Running Task
- Healthy Status

---

# Configure HTTPS

Attach the ECS service to an Application Load Balancer.

Configure:

- HTTP Listener
- HTTPS Listener
- ACM Certificate

---

# DNS

Configure:

```
api.shedma.com
```

to point to the Application Load Balancer.

---

# Google Cloud

Create:

- BigQuery Dataset
- BigQuery Table

Create a Service Account with BigQuery permissions.

Store the Service Account JSON in AWS Secrets Manager.

---

# Azure Frontend

Update the frontend API URL:

```javascript
const API = "https://api.shedma.com";
```

Push the frontend to GitHub.

Azure Static Web Apps automatically deploys the latest version.

---

# Verification

Verify:

- Frontend loads
- Swagger loads
- Health endpoint returns 200
- POST /events works
- GET /events returns stored data
- BigQuery receives events

---

# Deployment Checklist

- Docker image built
- Docker image tested
- Image pushed to ECR
- ECS updated
- HTTPS working
- DNS configured
- Azure deployed
- BigQuery connected
- CORS configured
- Secrets Manager configured
- CloudWatch logs healthy

Deployment is complete once all checks pass.