# Enterprise Tri-Cloud Analytics Platform

![Azure Static Web Apps](https://img.shields.io/badge/Azure-Static%20Web%20Apps-0078D4?logo=microsoftazure&logoColor=white)
![AWS ECS](https://img.shields.io/badge/AWS-ECS%20Fargate-FF9900?logo=amazonaws&logoColor=white)
![Google Cloud](https://img.shields.io/badge/Google-BigQuery-4285F4?logo=googlecloud&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Containerized-2496ED?logo=docker&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-REST%20API-009688?logo=fastapi&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-IaC-844FBA?logo=terraform&logoColor=white)

---

## Overview

The Enterprise Tri-Cloud Analytics Platform is a production-style cloud engineering portfolio project demonstrating how a modern application can span three major cloud providers while remaining secure, scalable, and maintainable.

Rather than deploying an application entirely within a single cloud, this project intentionally distributes responsibilities across Azure, Amazon Web Services (AWS), and Google Cloud Platform (GCP), simulating the type of multi-cloud architecture used by enterprise organizations.

The platform consists of:

- Azure Static Web Apps hosting the frontend
- AWS ECS Fargate hosting a Dockerized FastAPI backend
- AWS Application Load Balancer providing secure HTTPS access
- Google BigQuery serving as the analytics database
- Secure authentication using AWS Secrets Manager and Google Service Accounts

The result is a fully operational analytics platform capable of accepting events through a REST API, storing them in BigQuery, and displaying them through a responsive web interface.

---

# Live Demo

## Frontend

> # Live Demo

## Frontend

https://lemon-moss-02b6abe10.7.azurestaticapps.net/

## API Documentation (Swagger)

https://api.shedma.com/docs

## Health Check

https://api.shedma.com/health

## Swagger Documentation

> https://api.shedma.com/docs

## Health Endpoint

> https://api.shedma.com/health

---

# Architecture

```

```
                    Azure
        Static Web Apps Frontend
                │
                │ HTTPS
                ▼
        api.shedma.com
                │
                ▼
      AWS Application Load Balancer
                │
                ▼
      AWS ECS Fargate (Docker)
                │
                ▼
          FastAPI REST API
                │
                ▼
      Google BigQuery Dataset
```

---

# Project Objectives

This project demonstrates practical experience with:

- Multi-cloud architecture
- Cloud networking
- Containerization
- Infrastructure as Code
- Secure authentication
- REST API development
- Docker image management
- Cloud deployment pipelines
- Enterprise documentation
- Cost optimization

---

# Why Multi-Cloud?

Many organizations avoid vendor lock-in by distributing workloads across multiple cloud providers.

This project demonstrates that concept by assigning each cloud platform a dedicated responsibility.

## Microsoft Azure

Responsible for:

- Frontend Hosting
- Static Website Delivery
- Global CDN
- HTTPS
- GitHub Deployment Integration

---

## Amazon Web Services

Responsible for:

- Docker Container Registry (ECR)
- Container Orchestration (ECS)
- Load Balancing
- HTTPS Termination
- Secrets Management
- Networking
- Security Groups
- IAM

---

## Google Cloud Platform

Responsible for:

- Analytics Storage
- Data Persistence
- Event Querying
- BigQuery Dataset Management

---

# Technology Stack

## Frontend

- HTML5
- CSS3
- JavaScript

## Backend

- FastAPI
- Python
- Uvicorn

## Containers

- Docker
- Amazon ECR

## Cloud Infrastructure

Azure

- Static Web Apps

AWS

- ECS Fargate
- Application Load Balancer
- IAM
- Secrets Manager
- CloudWatch
- ECR

Google Cloud

- BigQuery
- Service Accounts

---

# Repository Structure

```

enterprise-tri-cloud-analytics/
│
├── apps/
│ ├── frontend/
│ └── backend/
│
├── infrastructure/
│ ├── aws/
│ ├── azure/
│ └── gcp/
│
├── docs/
│ ├── screenshots/
│ ├── diagrams/
│ ├── ARCHITECTURE.md
│ ├── TROUBLESHOOTING.md
│ ├── DEPLOYMENT.md
│ ├── DECISIONS.md
│ └── COST_ANALYSIS.md
│
├── README.md
├── LICENSE
└── .gitignore

```

---

# Request Lifecycle

A user opening the web application triggers the following workflow:

1. The browser loads the frontend from Azure Static Web Apps.
2. The frontend sends requests to `https://api.shedma.com`.
3. DNS resolves the request to the AWS Application Load Balancer.
4. The ALB forwards the request to the ECS Fargate service.
5. FastAPI processes the request.
6. FastAPI authenticates to Google BigQuery using a Google Service Account stored securely in AWS Secrets Manager.
7. Data is inserted into or queried from BigQuery.
8. The response is returned through AWS to the frontend running in Azure.

This architecture demonstrates secure communication across three independent cloud providers while keeping each service focused on its strengths.

---

# API Endpoints

| Method | Endpoint | Description |
|---------|----------|-------------|
| GET | `/` | Root endpoint |
| GET | `/health` | Health check |
| GET | `/events` | Retrieve stored events |
| POST | `/events` | Submit a new analytics event |

Example request:

```json
{
  "service": "frontend",
  "event": "button_click",
  "severity": "info",
  "description": "User submitted a demo event."
}
```
---

# Deployment Workflow

The platform is deployed across three cloud providers, with each platform responsible for a specific layer of the application.

## Frontend Deployment (Azure)

The frontend is hosted using **Azure Static Web Apps**.

Deployment workflow:

```text
GitHub Repository
        │
        ▼
Azure Static Web Apps
        │
        ▼
Global HTTPS Website
```

Each push to the configured branch automatically triggers a deployment through Azure's integrated GitHub workflow.

---

## Backend Deployment (AWS)

The backend is containerized with Docker and deployed to Amazon ECS Fargate.

Deployment workflow:

```text
FastAPI Source Code
        │
        ▼
Docker Build
        │
        ▼
Amazon ECR
        │
        ▼
Amazon ECS Task Definition
        │
        ▼
Amazon ECS Service
        │
        ▼
Application Load Balancer
        │
        ▼
HTTPS Endpoint
```

This architecture allows the backend to run without managing EC2 instances while remaining highly portable through Docker containers.

---

## Data Layer (Google Cloud)

Google BigQuery stores application events submitted through the REST API.

Workflow:

```text
REST API
      │
      ▼
Google Service Account
      │
      ▼
BigQuery Client
      │
      ▼
Dataset
      │
      ▼
raw_events Table
```

BigQuery serves as the analytical data warehouse for the application and demonstrates secure cross-cloud integration.

---

# Authentication

The backend authenticates to Google Cloud without embedding credentials inside the Docker image.

Authentication flow:

```text
Google Service Account JSON
          │
          ▼
AWS Secrets Manager
          │
          ▼
ECS Task Environment Variable
          │
          ▼
FastAPI
          │
          ▼
Google BigQuery
```

This approach keeps sensitive credentials outside the application source code and Docker image.

---

# Security

Security was incorporated throughout the project.

## HTTPS

All production traffic uses HTTPS.

Traffic encryption is provided using:

- AWS Certificate Manager (ACM)
- Application Load Balancer
- TLS termination

---

## IAM

AWS Identity and Access Management (IAM) controls permissions for:

- ECS Task Execution
- Secrets Manager access
- Amazon ECR
- CloudWatch logging

The principle of least privilege was followed wherever possible.

---

## Secrets Management

Google Cloud credentials are stored securely in AWS Secrets Manager.

Benefits include:

- No credentials committed to Git
- No credentials baked into Docker images
- Secure runtime injection
- Easier credential rotation

---

## Network Security

AWS Security Groups restrict inbound traffic.

Allowed traffic:

- HTTPS (443)
- HTTP (80, redirect to HTTPS)

Application containers remain behind the Application Load Balancer and are not exposed directly to the Internet.

---

## CORS

The FastAPI backend explicitly allows requests only from approved frontend origins.

Example:

```python
allow_origins = [
    "http://localhost:8080",
    "http://127.0.0.1:8080",
    "https://YOUR-AZURE-STATIC-WEB-APP.azurestaticapps.net"
]
```

This prevents unauthorized browser-based cross-origin requests while allowing the production frontend to communicate with the API.

---

# Docker

The backend is packaged into a Docker image to provide a consistent runtime environment.

Benefits:

- Platform-independent deployment
- Repeatable builds
- Easier testing
- Simplified deployment
- Cloud portability

The image is stored in Amazon Elastic Container Registry (ECR) before deployment to ECS.

---

# Infrastructure Components

## Azure

| Service | Purpose |
|----------|---------|
| Static Web Apps | Hosts frontend |
| GitHub Integration | Automatic deployments |
| HTTPS | Secure frontend delivery |

---

## AWS

| Service | Purpose |
|----------|---------|
| ECS Fargate | Runs backend containers |
| ECR | Stores Docker images |
| ALB | Load balancing |
| ACM | TLS certificates |
| Secrets Manager | Secure credential storage |
| IAM | Access control |
| CloudWatch | Logging and monitoring |

---

## Google Cloud

| Service | Purpose |
|----------|---------|
| BigQuery | Event storage |
| Service Accounts | Authentication |
| IAM | Dataset permissions |

---

# Monitoring

Application logs are collected through Amazon CloudWatch.

Logs assist with:

- Application debugging
- Startup verification
- Runtime exception analysis
- Deployment validation

Monitoring container logs significantly reduced troubleshooting time during development.

---

# Cost Optimization

Although designed as an enterprise demonstration platform, cost awareness was an important consideration.

## Azure

Frontend hosting remains within the selected hosting tier and incurs little or no cost for this project.

---

## Google Cloud

BigQuery usage remains within the free usage limits due to the project's small dataset and low query volume.

---

## AWS

The primary running costs originate from:

- Amazon ECS Fargate
- Application Load Balancer

To minimize expenses, the ECS service can be scaled to zero when demonstrations are not required.

Scaling back to one task restores the live application within minutes.

---

# Performance

The platform benefits from:

- Static frontend delivery through Azure
- Containerized backend services
- Managed load balancing
- Analytical storage optimized for read-heavy workloads

The architecture separates responsibilities across cloud providers while maintaining low operational complexity.
---

# Screenshots

The following screenshots demonstrate the completed platform.

## Frontend

![Frontend](docs/screenshots/01-frontend-live.png)

Azure Static Web Apps serving the production frontend.

---

## Swagger API Documentation

![Swagger](docs/screenshots/02-swagger.png)

Interactive FastAPI documentation available through the AWS Application Load Balancer.

---

## AWS ECS Service

![ECS](docs/screenshots/03-ecs-service.png)

Amazon ECS Fargate running the production backend container.

---

## Amazon ECR

![ECR](docs/screenshots/04-ecr.png)

Docker image repository used during deployment.

---

## Application Load Balancer

![ALB](docs/screenshots/05-alb.png)

Public HTTPS endpoint routing traffic to ECS.

---

## Google BigQuery

![BigQuery](docs/screenshots/06-bigquery.png)

Analytics events stored inside Google BigQuery.

---

## CloudWatch Logs

![CloudWatch](docs/screenshots/07-cloudwatch.png)

Container logs used for debugging and monitoring deployments.

---

## Final Working Platform

![Platform](docs/screenshots/08-final-platform.png)

End-to-end application showing successful communication between Azure, AWS, and Google Cloud.

---

# Lessons Learned

Building this project provided valuable experience in enterprise cloud engineering and highlighted many real-world operational challenges.

## Multi-Cloud Integration

Successfully integrating Azure, AWS, and Google Cloud requires careful planning around authentication, networking, and service responsibilities.

---

## Docker Image Management

Keeping Docker images synchronized between local development, Amazon ECR, and ECS task definitions is essential.

A mismatch between image versions or digests can result in outdated containers being deployed even when newer images exist.

---

## Cloud Authentication

Managing credentials securely across cloud providers is significantly more challenging than local development.

Using AWS Secrets Manager to securely provide Google Cloud credentials proved to be a reliable and production-friendly solution.

---

## Infrastructure Troubleshooting

Many deployment failures originated from configuration rather than application code.

Examples included:

- Incorrect Docker architecture
- Container startup commands
- Security group rules
- ECS task definitions
- CORS configuration
- Image version mismatches

Systematic troubleshooting proved more effective than making multiple configuration changes simultaneously.

---

## Documentation

Comprehensive documentation is just as important as the application itself.

A well-documented project enables others to understand, deploy, and maintain the platform more effectively.

---

# Future Improvements

Potential future enhancements include:

- User authentication
- Role-based access control (RBAC)
- Event filtering and search
- Dashboard visualizations
- Terraform automation for all cloud resources
- CI/CD for backend deployments
- Centralized logging
- Distributed tracing
- Metrics dashboards
- Kubernetes deployment
- Automated testing
- API versioning
- Cloud monitoring dashboards

---

# Skills Demonstrated

This project demonstrates practical experience with:

### Cloud Platforms

- Microsoft Azure
- Amazon Web Services
- Google Cloud Platform

### DevOps

- Docker
- ECS Fargate
- Container Registries
- Infrastructure as Code concepts
- Deployment Pipelines

### Backend Development

- FastAPI
- REST APIs
- Python
- JSON

### Databases

- Google BigQuery

### Security

- HTTPS
- TLS
- IAM
- Secrets Management
- Service Accounts
- CORS

### Architecture

- Multi-Cloud Design
- Cloud Networking
- Load Balancing
- Container Orchestration
- Enterprise Documentation

---

# Acknowledgements

This project was developed as a cloud engineering portfolio demonstrating enterprise deployment practices using services from Microsoft Azure, Amazon Web Services, and Google Cloud Platform.

Special thanks to the open-source communities behind:

- FastAPI
- Docker
- Python
- Terraform
- Google Cloud SDK
- AWS CLI
- Azure CLI

---

# License

This project is licensed under the MIT License.

See the LICENSE file for details.

---

# Author

**Your Name**

Cloud Engineer • Multi-Cloud Engineer • DevOps Enthusiast

LinkedIn:

https://www.linkedin.com/in/YOUR-LINKEDIN

GitHub:

https://github.com/YOUR-USERNAME

---

# Repository Topics

```
azure
aws
google-cloud
multicloud
ecs
fargate
docker
fastapi
bigquery
terraform
cloud-engineering
cloud-architecture
devops
rest-api
analytics
```

---

# Conclusion

The Enterprise Tri-Cloud Analytics Platform demonstrates how modern cloud-native applications can securely integrate services across multiple cloud providers while following enterprise engineering practices.

The project showcases:

- Multi-cloud architecture
- Secure cross-cloud authentication
- Containerized application deployment
- REST API development
- Infrastructure management
- Production-style documentation
- Cost-aware cloud operations

Beyond delivering a working application, the project reflects the complete engineering lifecycle—from architecture and deployment to debugging, documentation, optimization, and presentation—making it a comprehensive demonstration of practical cloud engineering skills.